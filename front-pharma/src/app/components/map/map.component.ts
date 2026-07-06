import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ReferenceService } from '../../services/reference.service';
import { Reference } from '../../models/reference.model';

interface StorageUnit {
  id: string;
  label: string;
  room: string;
  x: number;
  y: number;
  width: number;
  height: number;
}

interface Room {
  name: string;
  x: number;
  y: number;
  width: number;
  height: number;
}

interface LocatedItem {
  name: string;
  cip13: string;
  quantity: number;
  statut: string;
  unitId: string;
}

@Component({
  selector: 'app-map',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './map.component.html',
  styleUrl: './map.component.css',
})
export class MapComponent implements OnInit {
  rooms: Room[] = [
    { name: 'Salle de stockage principale', x: 20, y: 40, width: 460, height: 440 },
    { name: 'Réserve froide', x: 510, y: 40, width: 270, height: 200 },
    { name: 'Armoire sécurisée', x: 510, y: 280, width: 270, height: 200 },
  ];

  units: StorageUnit[] = [
    { id: 'A1', label: 'Étagère A1', room: 'Salle de stockage principale', x: 50, y: 90, width: 85, height: 150 },
    { id: 'A2', label: 'Étagère A2', room: 'Salle de stockage principale', x: 155, y: 90, width: 85, height: 150 },
    { id: 'A3', label: 'Étagère A3', room: 'Salle de stockage principale', x: 260, y: 90, width: 85, height: 150 },
    { id: 'A4', label: 'Étagère A4', room: 'Salle de stockage principale', x: 365, y: 90, width: 85, height: 150 },
    { id: 'B1', label: 'Étagère B1', room: 'Salle de stockage principale', x: 50, y: 300, width: 85, height: 150 },
    { id: 'B2', label: 'Étagère B2', room: 'Salle de stockage principale', x: 155, y: 300, width: 85, height: 150 },
    { id: 'B3', label: 'Étagère B3', room: 'Salle de stockage principale', x: 260, y: 300, width: 85, height: 150 },
    { id: 'B4', label: 'Étagère B4', room: 'Salle de stockage principale', x: 365, y: 300, width: 85, height: 150 },
    { id: 'F1', label: 'Frigo F1', room: 'Réserve froide', x: 535, y: 90, width: 100, height: 120 },
    { id: 'F2', label: 'Frigo F2', room: 'Réserve froide', x: 655, y: 90, width: 100, height: 120 },
    { id: 'S1', label: 'Coffre S1', room: 'Armoire sécurisée', x: 560, y: 330, width: 170, height: 120 },
  ];

  itemsByUnit = new Map<string, LocatedItem[]>();
  selectedUnit: StorageUnit | null = null;
  searchTerm = '';
  isLoading = false;

  constructor(private referenceService: ReferenceService) {}

  ngOnInit(): void {
    this.isLoading = true;
    this.referenceService.getReferences(1, 100).subscribe({
      next: (res) => {
        this.placeItems(res.data);
        this.isLoading = false;
      },
      error: () => {
        this.isLoading = false;
      },
    });
  }

  selectUnit(unit: StorageUnit): void {
    this.selectedUnit = this.selectedUnit?.id === unit.id ? null : unit;
  }

  itemsOf(unitId: string): LocatedItem[] {
    return this.itemsByUnit.get(unitId) ?? [];
  }

  get selectedItems(): LocatedItem[] {
    return this.selectedUnit ? this.itemsOf(this.selectedUnit.id) : [];
  }

  get searchMatches(): LocatedItem[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return [];
    }
    const matches: LocatedItem[] = [];
    this.itemsByUnit.forEach((items) => {
      for (const item of items) {
        if (
          item.name.toLowerCase().includes(term) ||
          item.cip13.includes(term)
        ) {
          matches.push(item);
        }
      }
    });
    return matches;
  }

  isHighlighted(unitId: string): boolean {
    return this.searchMatches.some((item) => item.unitId === unitId);
  }

  unitLabel(unitId: string): string {
    return this.units.find((unit) => unit.id === unitId)?.label ?? unitId;
  }

  unitFill(unit: StorageUnit): string {
    const items = this.itemsOf(unit.id);
    if (items.length === 0) {
      return '#e5e7eb';
    }
    if (items.some((item) => item.quantity === 0)) {
      return '#fca5a5';
    }
    if (items.some((item) => item.quantity <= 80)) {
      return '#fde68a';
    }
    return '#86efac';
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

  // Assigns each reference to a storage unit from its CIP13, so the same
  // item always lands on the same shelf without any location data in the API.
  private placeItems(references: Reference[]): void {
    this.itemsByUnit = new Map<string, LocatedItem[]>();
    for (const ref of references) {
      const unit = this.units[this.hash(ref.cip13) % this.units.length];
      const items = this.itemsByUnit.get(unit.id) ?? [];
      items.push({
        name: ref.name,
        cip13: ref.cip13,
        quantity: ref.quantity,
        statut: this.deriveStatus(ref.quantity),
        unitId: unit.id,
      });
      this.itemsByUnit.set(unit.id, items);
    }
  }

  private hash(value: string): number {
    let h = 0;
    for (let i = 0; i < value.length; i++) {
      h = (h * 31 + value.charCodeAt(i)) >>> 0;
    }
    return h;
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
