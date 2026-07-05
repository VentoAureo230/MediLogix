import { Injectable, signal } from '@angular/core';
import { Router } from '@angular/router';

const TOKEN_KEY = 'medilogix_token';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  // Reactive auth state derived from the stored token.
  readonly isAuthenticated = signal<boolean>(!!this.getToken());

  constructor(private router: Router) {}

  setToken(token: string): void {
    localStorage.setItem(TOKEN_KEY, token);
    this.isAuthenticated.set(true);
  }

  getToken(): string | null {
    return localStorage.getItem(TOKEN_KEY);
  }

  logout(): void {
    localStorage.removeItem(TOKEN_KEY);
    this.isAuthenticated.set(false);
    this.router.navigate(['/login']);
  }
}
