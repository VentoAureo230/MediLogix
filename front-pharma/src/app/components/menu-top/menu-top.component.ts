import { Component } from '@angular/core';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-menu-top',
  standalone: true,
  imports: [],
  templateUrl: './menu-top.component.html',
  styleUrl: './menu-top.component.css',
})
export class MenuTopComponent {
  constructor(private auth: AuthService) {}

  logout(): void {
    this.auth.logout();
  }
}
