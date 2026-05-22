export type UserRole = 'client' | 'lawyer' | 'admin';
export type ConsultationStatus = 'pending' | 'active' | 'completed' | 'cancelled';

export interface LawyerCard {
  id: string;
  slug: string;
  name: string;
  verified: boolean;
  score: number;
  specializations: string[];
  yearsExperience: number;
  consultationPriceSar: number;
  responseTimeMinutes: number;
}
