import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { MedicationService } from '../../services/medication.service';
import { WebSocketService } from '../../services/websocket.service';

interface Item {
  nom: string;
  categorie: string;
  emplacement: string;
  quantite: number;
  statut: string;
}

interface Items {
  medicament: Item[];
  instrument: Item[];
}

@Component({
  selector: 'app-store',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './store.component.html',
  styleUrl: './store.component.css'
})
export class StoreComponent implements OnInit {

  paginatedItems: any[] = [];
  itemsPerPage = 15;
  currentPage = 1;
  totalPages = 1;
  items: Items = {
    medicament: [],
    instrument: []
  };
  isLoading = false;

  constructor(
    private medication: MedicationService,
    private websocketService: WebSocketService
  ) { }

  ngOnInit(): void {
    this.isLoading = true;
    this.medication.getMedications().subscribe((data) => {
      this.items.medicament = data.map((med: any) => ({
        nom: med.name,
        categorie: med.category,
        emplacement: med.location,
        quantite: med.quantity,
        statut: med.availability
      }));
      this.updatePagination();
      this.isLoading = false;
    }, (error) => {
      alert('Error fetching medications' + error);
      this.isLoading = false;
    });

    this.websocketService.onNewMedication((newMedication) => {
      console.log('New medication received:', newMedication);
      this.medication.push(newMedication);
      this.updatePagination();
    });
  }

  ngOnDestroy() {
    this.websocketService.disconnect();
  }

  selectedTab: 'medicament' | 'instrument' = 'medicament';



  switchTab(tab: 'medicament' | 'instrument') {
    this.selectedTab = tab;
    this.updatePagination();
  }

  updatePagination() {
    const itemsForTab = this.items[this.selectedTab];
    this.totalPages = Math.ceil(itemsForTab.length / this.itemsPerPage);
    const start = (this.currentPage - 1) * this.itemsPerPage;
    const end = start + this.itemsPerPage;
    this.paginatedItems = itemsForTab.slice(start, end);
  }

  nextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.updatePagination();
    }
  }

  previousPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.updatePagination();
    }
  }

  getStockStatusClass(status: string): string {
    switch (status) {
      case 'En rupture':
        return 'bg-red-200 text-red-600';
      case 'Stock faible':
        return 'bg-yellow-200 text-yellow-600';
      case 'En stock':
        return 'bg-green-200 text-green-600';
      default:
        return 'bg-gray-200 text-gray-600';
    }
  }

  addStock(item: Item) {
    console.log(`Adding stock for: ${item.nom}`);
  }
}
