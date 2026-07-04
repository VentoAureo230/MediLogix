import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Paginated, Reference } from '../models/reference.model';

@Injectable({
  providedIn: 'root',
})
export class ReferenceService {
  private apiUrl = `${environment.api.url}/reference`;

  // Live list used by the store, fed by the initial fetch + websocket pushes.
  private referencesSubject = new BehaviorSubject<Reference[]>([]);
  references$ = this.referencesSubject.asObservable();

  constructor(private http: HttpClient) {}

  getReferences(page = 1, limit = 15): Observable<Paginated<Reference>> {
    const params = new HttpParams()
      .set('page', page)
      .set('limit', limit);
    return this.http.get<Paginated<Reference>>(this.apiUrl, { params });
  }

  updateQuantity(cip13: string, quantity: number): Observable<Reference> {
    return this.http.patch<Reference>(`${this.apiUrl}/${cip13}`, { quantity });
  }

  push(newReference: Reference) {
    const current = this.referencesSubject.getValue();
    this.referencesSubject.next([...current, newReference]);
  }
}
