import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'http://localhost:3000';

  constructor(private http: HttpClient) { }

  // Exemple de méthode GET pour obtenir des données
  getData(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/user/users`);
  }

  // Exemple de méthode POST pour envoyer des données
  postData(data: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/endpoint`, data);
  }
}
