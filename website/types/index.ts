// Wallpaper Types
export type WallpaperStatus = 'pending' | 'approved' | 'rejected';

export interface WallpaperStats {
  views: number;
  downloads: number;
  shares: number;
  favorites: number;
}

export interface Wallpaper {
  id: string;
  title: string;
  description: string;
  tags: string[];
  category: string;
  contributorId: string;
  contributorName: string;
  cloudinaryPublicId: string;
  imageUrl: string;
  thumbUrl: string;
  width: number;
  height: number;
  size: number;
  status: WallpaperStatus;
  rejectReason?: string;
  reviewedBy?: string;
  reviewedAt?: Date;
  stats: WallpaperStats;
  createdAt: Date;
  publishedAt?: Date;
}

// User / Auth Types
export type UserRole = 'admin' | 'contributor' | 'viewer';

export interface UserProfile {
  uid: string;
  name: string;
  email: string;
  role: UserRole;
  status: 'active' | 'suspended';
  payoutInfo?: PayoutInfo;
  createdAt: Date;
}

export interface PayoutInfo {
  method: 'upi' | 'bank';
  upiId?: string;
  accountNumber?: string;
  ifsc?: string;
  name: string;
}

// Category
export interface Category {
  id: string;
  name: string;
  icon: string;
  order: number;
  wallpaperCount: number;
  coverImageUrl?: string;
}

// Earnings
export interface MonthlyEarnings {
  id: string; // yyyy-mm
  totalRevenue: number;
  platformCut: number;
  contributorPool: number;
  perContributor: Record<string, number>;
  status: 'draft' | 'finalized' | 'paid';
}

export interface Payout {
  id: string;
  contributorId: string;
  contributorName: string;
  month: string; // yyyy-mm
  amount: number;
  status: 'pending' | 'paid';
  paidAt?: Date;
}

// Report
export interface Report {
  id: string;
  wallpaperId: string;
  reason: 'copyright' | 'abuse' | 'other';
  description?: string;
  status: 'open' | 'resolved' | 'dismissed';
  createdAt: Date;
}

// Upload
export interface UploadFormData {
  title: string;
  description: string;
  category: string;
  tags: string[];
  file: File | null;
}

// Cloudinary signed upload
export interface CloudinarySignature {
  signature: string;
  timestamp: number;
  apiKey: string;
  cloudName: string;
  uploadPreset: string;
  folder: string;
}
