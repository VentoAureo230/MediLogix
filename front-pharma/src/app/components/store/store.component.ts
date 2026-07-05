import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Subject, Subscription } from 'rxjs';
import { debounceTime, distinctUntilChanged } from 'rxjs/operators';
import { ReferenceService } from '../../services/reference.service';
import { WebSocketService } from '../../services/websocket.service';
import { Reference } from '../../models/reference.model';

interface Item {
  name: string;
  cip13: string;
  quantity: number;
  statut: string;
}

@Component({
  selector: 'app-store',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './store.component.html',
  styleUrl: './store.component.css',
})
export class StoreComponent implements OnInit, OnDestroy {
  items: Item[] = [];
  itemsPerPage = 15;
  currentPage = 1;
  totalPages = 1;
  total = 0;
  isLoading = false;
  searchTerm = '';

  private search$ = new Subject<string>();
  private searchSub?: Subscription;
  private wsUnsubscribe?: () => void;

  constructor(
    private referenceService: ReferenceService,
    private websocketService: WebSocketService,
  ) {}

  ngOnInit(): void {
    this.loadPage(1);

    // Debounce keystrokes so we don't hit the API on every character.
    this.searchSub = this.search$
      .pipe(debounceTime(300), distinctUntilChanged())
      .subscribe(() => this.loadPage(1));

    // A new reference created anywhere → refresh the current page.
    this.wsUnsubscribe = this.websocketService.onNewMedication(() => {
      this.loadPage(this.currentPage);
    });
  }

  ngOnDestroy(): void {
    this.wsUnsubscribe?.();
    this.searchSub?.unsubscribe();
  }

  onSearchChange(): void {
    this.search$.next(this.searchTerm);
  }

  loadPage(page: number): void {
    this.isLoading = true;
    this.referenceService
      .getReferences(
        page,
        this.itemsPerPage,
        undefined,
        this.searchTerm.trim() || undefined,
      )
      .subscribe({
        next: (res) => {
          this.items = res.data.map((ref) => this.toItem(ref));
          this.total = res.total;
          this.currentPage = res.page;
          this.totalPages = Math.max(1, Math.ceil(res.total / res.limit));
          this.isLoading = false;
        },
        error: () => {
          this.isLoading = false;
        },
      });
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) {
      this.loadPage(this.currentPage + 1);
    }
  }

  previousPage(): void {
    if (this.currentPage > 1) {
      this.loadPage(this.currentPage - 1);
    }
  }

  addStock(item: Item): void {
    const input = prompt(`Quantité à ajouter pour ${item.name} :`, '10');
    if (input === null) {
      return;
    }
    const qty = parseInt(input, 10);
    if (isNaN(qty) || qty <= 0) {
      return;
    }
    this.referenceService.updateQuantity(item.cip13, qty).subscribe({
      next: (updated) => {
        item.quantity = updated.quantity;
        item.statut = this.deriveStatus(updated.quantity);
      },
      error: () => alert('Échec de la mise à jour du stock'),
    });
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

  private toItem(ref: Reference): Item {
    return {
      name: ref.name,
      cip13: ref.cip13,
      quantity: ref.quantity,
      statut: this.deriveStatus(ref.quantity),
    };
  }

  private deriveStatus(quantity: number): string {
    if (quantity === 0) {
      return 'En rupture';
    }
    if (quantity <= 80) {
      return 'Stock faible';
    }
    return 'En stock';
  }
}
