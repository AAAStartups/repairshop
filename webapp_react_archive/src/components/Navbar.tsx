import React from 'react';
import { Shield, MapPin, PhoneCall, UserCheck, Wrench, Clock, CheckCircle2 } from 'lucide-react';

interface NavbarProps {
  onOpenBooking: () => void;
  onOpenTrack: () => void;
  onOpenWarranty: () => void;
  onOpenTechnician: () => void;
  onOpenAuth: () => void;
  userPhone: string | null;
}

export const Navbar: React.FC<NavbarProps> = ({
  onOpenBooking,
  onOpenTrack,
  onOpenWarranty,
  onOpenTechnician,
  onOpenAuth,
  userPhone,
}) => {
  return (
    <nav style={{
      backgroundColor: '#080C0A',
      borderBottom: '1px solid #1F2D27',
      position: 'sticky',
      top: 0,
      zIndex: 100,
      padding: '12px clamp(12px, 3vw, 24px)',
    }}>
      <div style={{
        maxWidth: 1200,
        margin: '0 auto',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        flexWrap: 'wrap',
        gap: 12,
      }}>
        {/* Brand */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, cursor: 'pointer' }} onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}>
          <div style={{
            width: 40,
            height: 40,
            borderRadius: 12,
            backgroundColor: 'rgba(237, 176, 0, 0.15)',
            border: '1.5px solid #EDB000',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: 20,
          }}>
            ⚡
          </div>
          <div>
            <div style={{ fontSize: 18, fontWeight: 900, color: '#FFFFFF', letterSpacing: '-0.3px', display: 'flex', alignItems: 'center', gap: 6 }}>
              QuickFix
              <span style={{ fontSize: 10, backgroundColor: '#EDB000', color: '#003A26', padding: '2px 6px', borderRadius: 6, fontWeight: 800 }}>PRO</span>
            </div>
            <div style={{ fontSize: 10.5, color: '#EDB000', fontWeight: 600, letterSpacing: '0.4px' }}>
              CLASS-100 CLEANROOM LAB CARE
            </div>
          </div>
        </div>

        {/* Live Location Hub Pill */}
        <div className="nav-location-pill">
          <div style={{
            width: 8,
            height: 8,
            borderRadius: '50%',
            backgroundColor: '#10B981',
            boxShadow: '0 0 8px #10B981',
          }} className="pulse-dot" />
          <MapPin size={13} color="#EDB000" />
          <span>Indiranagar Central Hub • <strong>14 Techs Active</strong></span>
        </div>

        {/* Action Navigation */}
        <div className="nav-actions">
          <button
            onClick={onOpenTrack}
            style={{
              background: 'transparent',
              border: '1px solid rgba(255,255,255,0.15)',
              color: '#FFFFFF',
              borderRadius: 10,
              padding: '8px 12px',
              fontSize: 12.5,
              fontWeight: 700,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: 6,
            }}
          >
            <Clock size={15} color="#EDB000" />
            Track Order
          </button>

          <button
            onClick={onOpenWarranty}
            className="nav-hide-mobile"
            style={{
              background: 'transparent',
              border: '1px solid rgba(255,255,255,0.15)',
              color: '#FFFFFF',
              borderRadius: 10,
              padding: '8px 14px',
              fontSize: 13,
              fontWeight: 700,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: 6,
            }}
          >
            <Shield size={15} color="#10B981" />
            180-Day Warranty
          </button>

          <button
            onClick={onOpenTechnician}
            className="nav-hide-mobile"
            style={{
              background: 'rgba(0, 58, 38, 0.4)',
              border: '1px solid #003A26',
              color: '#EDB000',
              borderRadius: 10,
              padding: '8px 12px',
              fontSize: 12.5,
              fontWeight: 700,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: 6,
            }}
          >
            <Wrench size={14} />
            Field Tech
          </button>

          <button
            onClick={onOpenBooking}
            className="btn-primary"
            style={{ padding: '8px 14px', fontSize: 12.5 }}
          >
            Book Free Pickup →
          </button>

          <button
            onClick={onOpenAuth}
            style={{
              background: '#121915',
              border: '1px solid #1F2D27',
              color: userPhone ? '#10B981' : '#FFFFFF',
              borderRadius: 10,
              padding: '8px 12px',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              gap: 6,
              fontSize: 12,
              fontWeight: 700,
            }}
          >
            <UserCheck size={14} />
            {userPhone ? userPhone.slice(-4) : 'Sign In'}
          </button>
        </div>
      </div>
    </nav>
  );
};
