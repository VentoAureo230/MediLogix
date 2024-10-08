import { Component, OnInit } from '@angular/core';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {
  
  constructor(private apiService: ApiService) { }

  ngOnInit() {
    this.apiService.getData().subscribe(
      data => {
        console.log('Data from API:', data);
      },
      error => {
        console.error('Error:', error);
      }
    );
  }
}
