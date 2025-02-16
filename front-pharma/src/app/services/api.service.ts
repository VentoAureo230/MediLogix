import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'http://localhost:3000/authentication';

  constructor(private http: HttpClient) { }

  login(email:string, password: string): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/login`, { email, password });
  }

  register(email: string, password: string, firstName: string, lastName: string): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/register`, { email, password, firstName, lastName });
  }

  // Exemple de méthode GET pour obtenir des données
  getData(): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/user/users`);
  }

  // Exemple de méthode POST pour envoyer des données
  postData(data: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/endpoint`, data);
  }
}
