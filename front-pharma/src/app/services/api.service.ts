import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, tap } from 'rxjs';
import { environment } from '../../environments/environment';
import { LoginResponse, Role } from '../models/reference.model';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  private authUrl = `${environment.api.url}/authentication`;

  constructor(
    private http: HttpClient,
    private auth: AuthService,
  ) {}

  login(email: string, password: string): Observable<LoginResponse> {
    return this.http
      .post<LoginResponse>(`${this.authUrl}/login`, { email, password })
      .pipe(tap((res) => this.auth.setToken(res.token)));
  }

  register(email: string, password: string, role: Role): Observable<any> {
    return this.http.post<any>(`${this.authUrl}`, { email, password, role });
  }
}
