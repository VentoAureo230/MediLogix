import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class MedicationService {
  private apiUrl = 'http://localhost:3000/medication';
  private medicationsSubject = new BehaviorSubject<any[]>([]);
  medications$ = this.medicationsSubject.asObservable();

  constructor(private http: HttpClient) { }

  getMedications(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}`);
  }

  push(newMedication: any) {
    const currentMedications = this.medicationsSubject.getValue();
    this.medicationsSubject.next([...currentMedications, newMedication]);
  }
}