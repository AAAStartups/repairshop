import React, { useState } from 'react';
import { Navbar } from './components/Navbar';
import { BookingModal } from './components/BookingModal';
import { TrackingModal } from './components/TrackingModal';
import { WarrantyModal } from './components/WarrantyModal';
import { TechnicianModal } from './components/TechnicianModal';
import { AuthModal } from './components/AuthModal';
import { ShieldCheck, Clock, CheckCircle2, Wrench, Sparkles, MapPin, ChevronRight, Phone, Award } from 'lucide-react';
import { mockBrands, mockRepairs } from './api/client';

export const App: React.FC = () => {
  const [isBookingOpen, setIsBookingOpen] = useState(false);
  const [isTrackingOpen, setIsTrackingOpen] = useState(false);
  const [isWarrantyOpen, setIsWarrantyOpen] = useState(false);
  const [isTechnicianOpen, setIsTechnicianOpen] = useState(false);
  const [isAuthOpen, setIsAuthOpen] = useState(false);

  const [activeOrderId, setActiveOrderId] = useState('QF-89421');
  const [warrantyDetails, setWarrantyDetails] = useState({
    orderId: 'QF-77210',
    device: 'Apple iPhone 15 Pro Max',
    amount: 3899,
  });

  const [userPhone, setUserPhone] = useState<string | null>(
    localStorage.getItem('quickfix_user_phone') || null
  );

  const handleBookingSuccess = (bookingNumber: string) => {
    setActiveOrderId(bookingNumber);
    setIsTrackingOpen(true);
  };

  const handleOpenWarrantyFromTrack = (orderId: string, device: string, amount: number) => {
    setWarrantyDetails({ orderId, device, amount });
    setIsTrackingOpen(false);
    setIsWarrantyOpen(true);
  };

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <Navbar
        onOpenBooking={() => setIsBookingOpen(true)}
        onOpenTrack={() => setIsTrackingOpen(true)}
        onOpenWarranty={() => setIsWarrantyOpen(true)}
        onOpenTechnician={() => setIsTechnicianOpen(true)}
        onOpenAuth={() => setIsAuthOpen(true)}
        userPhone={userPhone}
      />

      {/* HERO SECTION */}
      <section style={{
        background: 'linear-gradient(180deg, #080C0A 0%, #003A26 65%, #080C0A 100%)',
        color: 'white',
        padding: '60px 24px 80px 24px',
        position: 'relative',
        overflow: 'hidden',
      }}>
        <div style={{ maxWidth: 1100, margin: '0 auto', textAlign: 'center', position: 'relative', zIndex: 1 }}>
          <div style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: 8,
            backgroundColor: 'rgba(237, 176, 0, 0.12)',
            border: '1px solid #EDB000',
            color: '#EDB000',
            padding: '6px 14px',
            borderRadius: 20,
            fontSize: 12,
            fontWeight: 800,
            letterSpacing: '0.4px',
            marginBottom: 20,
          }}>
            <Sparkles size={14} />
            ZERO ADVANCE PAYMENT • 180-DAY DIAMOND WARRANTY
          </div>

          <h1 style={{
            fontSize: 'clamp(32px, 5vw, 56px)',
            fontWeight: 900,
            lineHeight: 1.15,
            letterSpacing: '-1px',
            marginBottom: 20,
          }}>
            Premium Smartphone &amp; Electronics Care.<br />
            <span style={{ color: '#EDB000' }}>Doorstep Pickup in 30 Minutes.</span>
          </h1>

          <p style={{
            fontSize: 'clamp(15px, 2vw, 18px)',
            color: 'rgba(255,255,255,0.85)',
            maxWidth: 720,
            margin: '0 auto 32px auto',
            lineHeight: 1.6,
          }}>
            Class-100 cleanroom lab repairs with genuine OEM components. Our certified technician collects your device in a tamper-proof barcode pouch. Pay only after complete doorstep testing.
          </p>

          <div style={{ display: 'flex', justifyContent: 'center', gap: 14, flexWrap: 'wrap' }}>
            <button
              onClick={() => setIsBookingOpen(true)}
              className="btn-primary"
              style={{ fontSize: 16, padding: '14px 32px' }}
            >
              Book Free Doorstep Pickup →
            </button>
            <button
              onClick={() => setIsTrackingOpen(true)}
              className="btn-secondary"
              style={{ fontSize: 16, padding: '14px 28px', backgroundColor: 'transparent', color: 'white', borderColor: 'rgba(255,255,255,0.3)' }}
            >
              <Clock size={16} color="#EDB000" />
              Track Active Repair #{activeOrderId}
            </button>
          </div>

          {/* 4 Trust Columns */}
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
            gap: 16,
            marginTop: 48,
          }}>
            {[
              { icon: '💰', title: 'Zero Advance Policy', desc: 'Pay ₹0 upfront. Full payment due only after satisfaction inspection.' },
              { icon: '🛡️', title: '180-Day Guarantee', desc: 'Diamond warranty coverage on all replaced screens, batteries & boards.' },
              { icon: '🔬', title: 'Class-100 Cleanroom', desc: 'Dust-free electrostatic discharge (ESD) certified repair facility.' },
              { icon: '🔒', title: 'Tamper-Proof Pouch', desc: 'Device barcode-sealed in your presence before transit.' },
            ].map((col, idx) => (
              <div
                key={idx}
                style={{
                  backgroundColor: 'rgba(255, 255, 255, 0.05)',
                  border: '1px solid rgba(255, 255, 255, 0.1)',
                  borderRadius: 18,
                  padding: 20,
                  textAlign: 'left',
                }}
              >
                <div style={{ fontSize: 24, marginBottom: 8 }}>{col.icon}</div>
                <div style={{ fontSize: 14, fontWeight: 800, color: '#FFFFFF', marginBottom: 4 }}>{col.title}</div>
                <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.7)', lineHeight: 1.4 }}>{col.desc}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* POPULAR BRANDS SECTION */}
      <section style={{ maxWidth: 1100, margin: '40px auto', padding: '0 24px', width: '100%' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 20 }}>
          <div>
            <div style={{ fontSize: 12, fontWeight: 800, color: '#10B981', letterSpacing: '0.6px', textTransform: 'uppercase' }}>
              Genuine OEM Manufacturers
            </div>
            <h2 style={{ fontSize: 24, fontWeight: 900, color: '#003A26' }}>
              Select Your Device Brand
            </h2>
          </div>
          <button
            onClick={() => setIsBookingOpen(true)}
            style={{ background: 'none', border: 'none', color: '#003A26', fontWeight: 800, fontSize: 13, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4 }}
          >
            View All Brands <ChevronRight size={14} />
          </button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(130px, 1fr))', gap: 14 }}>
          {mockBrands.map((b) => (
            <div
              key={b.id}
              onClick={() => setIsBookingOpen(true)}
              className="brand-select-card"
              title={`Book repair for ${b.name}`}
            >
              <div className="brand-logo-pill">
                <img
                  src={b.logoAsset || `/assets/brands/${b.slug || b.id}.png`}
                  alt={`${b.name} official logo`}
                  className="brand-logo-img"
                  onError={(e) => {
                    const target = e.currentTarget;
                    target.style.display = 'none';
                    const parent = target.parentElement;
                    if (parent && !parent.querySelector('.brand-fallback')) {
                      const span = document.createElement('span');
                      span.className = 'brand-fallback';
                      span.style.fontSize = '24px';
                      span.textContent = '📱';
                      parent.appendChild(span);
                    }
                  }}
                />
              </div>
              <div style={{ fontSize: 13, fontWeight: 800, color: '#003A26' }}>{b.name}</div>
              {b.subtitle && (
                <div style={{ fontSize: 10, color: '#5F6F67', fontWeight: 600, marginTop: 1 }}>{b.subtitle}</div>
              )}
              <div style={{ fontSize: 10, color: '#10B981', fontWeight: 700, marginTop: 4 }}>In Stock ✓</div>
            </div>
          ))}
        </div>
      </section>

      {/* POPULAR SERVICES GRID */}
      <section style={{ maxWidth: 1100, margin: '20px auto 60px auto', padding: '0 24px', width: '100%' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginBottom: 20 }}>
          <div>
            <div style={{ fontSize: 12, fontWeight: 800, color: '#10B981', letterSpacing: '0.6px', textTransform: 'uppercase' }}>
              Precision Services
            </div>
            <h2 style={{ fontSize: 24, fontWeight: 900, color: '#003A26' }}>
              Popular Cleanroom Repairs
            </h2>
          </div>
          <button
            onClick={() => setIsBookingOpen(true)}
            style={{ background: 'none', border: 'none', color: '#003A26', fontWeight: 800, fontSize: 13, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 4 }}
          >
            Explore Catalog <ChevronRight size={14} />
          </button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', gap: 16 }}>
          {mockRepairs.map((r) => (
            <div
              key={r.id}
              onClick={() => setIsBookingOpen(true)}
              style={{
                backgroundColor: 'white',
                border: '1px solid #E8ECEA',
                borderRadius: 20,
                padding: 20,
                cursor: 'pointer',
                transition: 'all 0.2s',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
                boxShadow: '0 4px 12px rgba(0, 58, 38, 0.03)',
              }}
            >
              <div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 8 }}>
                  <h3 style={{ fontSize: 15, fontWeight: 800, color: '#003A26' }}>{r.title}</h3>
                  {r.badge && (
                    <span style={{ backgroundColor: '#EDB000', color: '#003A26', fontSize: 10, padding: '2px 8px', borderRadius: 6, fontWeight: 800 }}>
                      {r.badge}
                    </span>
                  )}
                </div>
                <p style={{ fontSize: 12.5, color: '#5F6F67', lineHeight: 1.5, marginBottom: 16 }}>{r.description}</p>
              </div>

              <div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderTop: '1px solid #F3F6F4', paddingTop: 12 }}>
                  <div>
                    <div style={{ fontSize: 10, color: '#5F6F67', fontWeight: 700 }}>FIXED ESTIMATE</div>
                    <div style={{ fontSize: 18, fontWeight: 900, color: '#003A26' }}>₹{r.price}</div>
                  </div>
                  <div style={{ textAlign: 'right' }}>
                    <div style={{ fontSize: 10.5, color: '#10B981', fontWeight: 700 }}>🛡️ {r.warrantyDays} Days Warranty</div>
                    <div style={{ fontSize: 10.5, color: '#5F6F67' }}>⏱ {r.turnaroundMinutes / 60} hrs turnaround</div>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* FOOTER */}
      <footer style={{
        backgroundColor: '#080C0A',
        color: 'white',
        padding: '40px 24px',
        marginTop: 'auto',
        borderTop: '1px solid #1F2D27',
      }}>
        <div style={{
          maxWidth: 1100,
          margin: '0 auto',
          display: 'flex',
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: 24,
        }}>
          <div>
            <div style={{ fontSize: 18, fontWeight: 900, color: '#FFFFFF', marginBottom: 6 }}>
              QuickFix <span style={{ color: '#EDB000' }}>Care</span>
            </div>
            <div style={{ fontSize: 12, color: '#94A3B8', maxWidth: 360, lineHeight: 1.5 }}>
              India's premier luxury electronics repair ecosystem. Class-100 cleanroom diagnostics, tamper-proof logistics, and Zero Advance Payment guarantee.
            </div>
          </div>

          <div>
            <div style={{ fontSize: 12, fontWeight: 800, color: '#EDB000', marginBottom: 8, letterSpacing: '0.6px' }}>
              DIRECT CONCIERGE HELPLINE
            </div>
            <div style={{ fontSize: 18, fontWeight: 800, color: 'white' }}>1800-QUICKFIX (Toll-Free)</div>
            <div style={{ fontSize: 12, color: '#94A3B8', marginTop: 4 }}>care@quickfix.care • Indiranagar Cleanroom Lab, Bengaluru</div>
          </div>
        </div>
        <div style={{ maxWidth: 1100, margin: '24px auto 0 auto', paddingTop: 16, borderTop: '1px solid #1F2D27', fontSize: 11, color: '#5F6F67', textAlign: 'center' }}>
          © 2026 QuickFix Technologies Pvt. Ltd. All rights reserved. Identical Android, iOS, and Webapp architecture.
        </div>
      </footer>

      {/* MODALS */}
      <BookingModal
        isOpen={isBookingOpen}
        onClose={() => setIsBookingOpen(false)}
        onBookingSuccess={handleBookingSuccess}
      />

      <TrackingModal
        isOpen={isTrackingOpen}
        onClose={() => setIsTrackingOpen(false)}
        orderId={activeOrderId}
        onOpenWarranty={handleOpenWarrantyFromTrack}
      />

      <WarrantyModal
        isOpen={isWarrantyOpen}
        onClose={() => setIsWarrantyOpen(false)}
        orderId={warrantyDetails.orderId}
        deviceName={warrantyDetails.device}
        amount={warrantyDetails.amount}
      />

      <TechnicianModal
        isOpen={isTechnicianOpen}
        onClose={() => setIsTechnicianOpen(false)}
      />

      <AuthModal
        isOpen={isAuthOpen}
        onClose={() => setIsAuthOpen(false)}
        onSuccess={(phone) => setUserPhone(phone)}
      />
    </div>
  );
};
