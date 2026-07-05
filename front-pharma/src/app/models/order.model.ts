import { Role } from './reference.model';

export interface OrderLine {
  quantity: number;
  reference: {
    id: number;
    name: string;
    cip13: string;
  };
}

export interface Order {
  id: number;
  user_id: number;
  status: string;
  created_at: string;
  updated_at: string;
  user: {
    id: number;
    email: string;
    role: Role;
  };
  references: OrderLine[];
}
