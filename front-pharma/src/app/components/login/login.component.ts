import { Component, OnInit } from '@angular/core';
import { ApiService } from '../../services/api.service';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  title: string = 'Login';
  loginEmail: string = '';
  loginPassword: string = '';

  registerEmail: string = '';
  registerPassword: string = '';
  registerFirstName: string = '';
  registerLastName: string = '';

  constructor(
    private apiService: ApiService,
    private router: Router
  ) { }

  ngOnInit(): void { }

  onLogin() {
    this.apiService.login(this.loginEmail, this.loginPassword).subscribe(
      (data) => {
        console.log(data);
        if(data) {
          this.router.navigate(['/home']);
        } else {
          alert('Invalid credentials');
        }
      },
      (error) => {
        console.log(error);
      }
    );
  }

  onRegister() {
    this.apiService.register(this.registerEmail, this.registerPassword, this.registerFirstName, this.registerLastName).subscribe(
      (data) => {
        console.log(data);
      },
      (error) => {
        console.log(error);
      }
    );
  }
}