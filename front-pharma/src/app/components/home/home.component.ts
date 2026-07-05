import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReferenceService } from '../../services/reference.service';
import { OrderService } from '../../services/order.service';
import { Order } from '../../models/order.model';

interface AlertRow {
  name: string;
  quantity: number;
  statut: string;
}

const ALERT_THRESHOLD = 80;

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css',
})
export class HomeComponent implements OnInit {
  medicationAlerts: AlertRow[] = [];

  // No instrument data model exists in the API yet — mocked for now.
  instrumentAlerts: AlertRow[] = [
    { name: 'Écarteur', quantity: 0, statut: 'En rupture' },
    { name: 'Scalpel', quantity: 0, statut: 'En rupture' },
    { name: 'Pince chirurgicale', quantity: 3, statut: 'Stock faible' },
    { name: 'Bistouri', quantity: 4, statut: 'Stock faible' },
    { name: 'Seringue', quantity: 5, statut: 'Stock faible' },
    { name: 'Clamp vasculaire', quantity: 6, statut: 'Stock faible' },
    { name: 'Pince hémostatique', quantity: 8, statut: 'Stock faible' },
    { name: 'Ciseaux chirurgicaux', quantity: 12, statut: 'Stock faible' },
    { name: 'Aiguille de suture', quantity: 15, statut: 'Stock faible' },
    { name: 'Porte-aiguille', quantity: 20, statut: 'Stock faible' },
  ];

  newOrders: Order[] = [];

  constructor(
    private referenceService: ReferenceService,
    private orderService: OrderService,
  ) {}

  ngOnInit(): void {
    this.referenceService.getReferences(1, 10, ALERT_THRESHOLD).subscribe({
      next: (res) => {
        this.medicationAlerts = res.data.map((ref) => ({
          name: ref.name,
          quantity: ref.quantity,
          statut: this.deriveStatus(ref.quantity),
        }));
      },
      error: () => {
        this.medicationAlerts = [];
      },
    });

    this.orderService.getOrders('New').subscribe({
      next: (orders) => {
        this.newOrders = orders;
      },
      error: () => {
        this.newOrders = [];
      },
    });
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'En rupture':
        return 'bg-red-200 text-red-600';
      case 'Stock faible':
        return 'bg-yellow-200 text-yellow-600';
      default:
        return 'bg-green-200 text-green-600';
    }
  }

  private deriveStatus(quantity: number): string {
    if (quantity === 0) {
      return 'En rupture';
    }
    if (quantity <= ALERT_THRESHOLD) {
      return 'Stock faible';
    }
    return 'En stock';
  }
}
