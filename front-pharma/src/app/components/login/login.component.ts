import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api.service';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Role } from '../../models/reference.model';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  loginEmail = '';
  loginPassword = '';
  loginError = '';

  registerEmail = '';
  registerPassword = '';
  registerRole: Role = 'Pharmacist';
  registerMessage = '';
  readonly roles: Role[] = ['Admin', 'Doctor', 'Pharmacist'];

  constructor(
    private apiService: ApiService,
    private router: Router,
  ) {}

  onLogin() {
    this.loginError = '';
    this.apiService.login(this.loginEmail, this.loginPassword).subscribe({
      next: () => this.router.navigate(['/home']),
      error: () => {
        this.loginError = 'Email ou mot de passe invalide.';
      },
    });
  }

  onRegister() {
    this.registerMessage = '';
    this.apiService
      .register(this.registerEmail, this.registerPassword, this.registerRole)
      .subscribe({
        next: () => {
          this.registerMessage = 'Compte créé, vous pouvez vous connecter.';
        },
        error: () => {
          this.registerMessage = "Échec de l'inscription.";
        },
      });
  }
}
