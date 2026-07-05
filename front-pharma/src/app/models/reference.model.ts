export interface Reference {
  id: number;
  name: string;
  cip7: string;
  cip13: string;
  quantity: number;
  created_at: string;
  updated_at: string;
}

export interface Paginated<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
}

export type Role = 'Admin' | 'Doctor' | 'Pharmacist';

export interface LoginResponse {
  token: string;
}
