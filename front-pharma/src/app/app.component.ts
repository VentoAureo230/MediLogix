import { Component } from '@angular/core';
import { RouterOutlet, Router } from '@angular/router';
import { MenuTopComponent } from './components/menu-top/menu-top.component';
import { CommonModule } from '@angular/common';
import { MenuLeftComponent } from './components/menu-left/menu-left.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, MenuTopComponent, MenuLeftComponent ,CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  constructor(private router: Router) { }

  isLoginPage(): boolean {
    return this.router.url === '/login';
  }
}
