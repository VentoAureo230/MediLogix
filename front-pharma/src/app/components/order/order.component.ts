import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { OrderService } from '../../services/order.service';
import { Order } from '../../models/order.model';

@Component({
  selector: 'app-order',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './order.component.html',
  styleUrl: './order.component.css',
})
export class OrderComponent implements OnInit {
  orders: Order[] = [];
  paginatedOrders: Order[] = [];
  itemsPerPage = 10;
  currentPage = 1;
  totalPages = 1;
  isLoading = false;
  expandedOrderId: number | null = null;

  constructor(private orderService: OrderService) {}

  ngOnInit(): void {
    this.isLoading = true;
    this.orderService.getOrders().subscribe({
      next: (data) => {
        this.orders = data;
        this.totalPages = Math.max(
          1,
          Math.ceil(this.orders.length / this.itemsPerPage),
        );
        this.updatePagination();
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      },
    });
  }

  updatePagination(): void {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    this.paginatedOrders = this.orders.slice(start, start + this.itemsPerPage);
  }

  toggleOrder(id: number): void {
    this.expandedOrderId = this.expandedOrderId === id ? null : id;
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.expandedOrderId = null;
      this.updatePagination();
    }
  }

  previousPage(): void {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.expandedOrderId = null;
      this.updatePagination();
    }
  }

  getStatusClass(status: string): string {
    switch (status) {
      case 'New':
        return 'bg-blue-200 text-blue-600';
      case 'Ongoing':
        return 'bg-yellow-200 text-yellow-600';
      case 'Ready':
        return 'bg-green-200 text-green-600';
      case 'Cancelled':
        return 'bg-red-200 text-red-600';
      default:
        return 'bg-gray-200 text-gray-600';
    }
  }
}
