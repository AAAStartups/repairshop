import React from 'react';
import { X, ShieldCheck, Download, Share2 } from 'lucide-react';

interface WarrantyModalProps {
  isOpen: boolean;
  onClose: () => void;
  orderId: string;
  deviceName?: string;
  amount?: number;
}

export const WarrantyModal: React.FC<WarrantyModalProps> = ({
  isOpen,
  onClose,
  orderId,
  deviceName = 'Apple iPhone 15 Pro',
  amount = 3899,
}) => {
  if (!isOpen) return null;

  return (
    <div style={{
      position: 'fixed',
      inset: 0,
      backgroundColor: 'rgba(8, 12, 10, 0.8)',
      backdropFilter: 'blur(10px)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      zIndex: 1000,
      padding: 16,
    }}>
      <div style={{
        backgroundColor: '#FFFFFF',
        borderRadius: 24,
        width: '100%',
        maxWidth: 680,
        maxHeight: '92vh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
        boxShadow: '0 24px 60px rgba(0, 58, 38, 0.25)',
        border: '1.5px solid #EDB000',
      }}>
        {/* Certificate Header Foil */}
        <div style={{
          background: 'linear-gradient(135deg, #003A26, #080C0A)',
          padding: '24px 28px',
          color: 'white',
          position: 'relative',
        }}>
          <button
            onClick={onClose}
            style={{
              position: 'absolute',
              top: 16,
              right: 16,
              background: 'rgba(255,255,255,0.1)',
              border: 'none',
              borderRadius: 10,
              width: 34,
              height: 34,
              cursor: 'pointer',
              color: 'white',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            <X size={16} />
          </button>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 12 }}>
            <div style={{
              width: 44,
              height: 44,
              borderRadius: 14,
              backgroundColor: 'rgba(237, 176, 0, 0.2)',
              border: '1.5px solid #EDB000',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              color: '#EDB000',
            }}>
              <ShieldCheck size={24} />
            </div>
            <div>
              <div style={{ fontSize: 18, fontWeight: 900, letterSpacing: '-0.3px' }}>QuickFix Care</div>
              <div style={{ fontSize: 10.5, color: '#EDB000', fontWeight: 800, letterSpacing: '0.8px' }}>
                CLASS-100 CLEANROOM LAB CERTIFIED
              </div>
            </div>
          </div>

          <div style={{
            fontSize: 14,
            fontWeight: 800,
            color: '#EDB000',
            letterSpacing: '1px',
            textAlign: 'center',
            marginTop: 14,
          }}>
            DIAMOND SERVICE WARRANTY CERTIFICATE
          </div>
          <div style={{ fontSize: 11, textAlign: 'center', color: 'rgba(255,255,255,0.7)', marginTop: 4 }}>
            Certificate ID: QF-WAR-{orderId.replace('QF-', '')} • 180 Days Protection
          </div>
        </div>

        {/* Certificate Content */}
        <div style={{ padding: 24, overflowY: 'auto', flex: 1 }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: 18 }}>
            <div>
              <div style={{ fontSize: 10.5, color: '#5F6F67', fontWeight: 700, textTransform: 'uppercase' }}>Serviced Device</div>
              <div style={{ fontSize: 15, fontWeight: 800, color: '#003A26', marginTop: 2 }}>{deviceName}</div>
            </div>
            <div>
              <div style={{ fontSize: 10.5, color: '#5F6F67', fontWeight: 700, textTransform: 'uppercase' }}>Service Order Ticket</div>
              <div style={{ fontSize: 15, fontWeight: 800, color: '#003A26', marginTop: 2 }}>{orderId}</div>
            </div>
          </div>

          <div style={{ borderTop: '1px solid #E8ECEA', paddingTop: 14, marginBottom: 18 }}>
            <div style={{ fontSize: 11, fontWeight: 800, color: '#5F6F67', marginBottom: 10 }}>COVERED COMPONENTS</div>
            <div style={{ fontSize: 12.5, color: '#1F2D27', lineHeight: 1.8 }}>
              <div>✓ OEM Grade Display & 120Hz Touch Digitizer Panel</div>
              <div>✓ Waterproofing Perimeter Gasket & Cleanroom Frame Adhesive</div>
              <div>✓ Zero Touch Sensitivity Loss Guarantee</div>
              <div>✓ Free Doorstep Re-Inspection if defects occur within 180 days</div>
            </div>
          </div>

          {/* Tax Invoice Breakdown */}
          <div style={{ backgroundColor: '#F8FAF9', borderRadius: 16, padding: 16, marginBottom: 18, border: '1px solid #E8ECEA' }}>
            <div style={{ fontSize: 11, fontWeight: 800, color: '#5F6F67', marginBottom: 10 }}>TAX INVOICE (ZERO ADVANCE FULFILLED)</div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, marginBottom: 6 }}>
              <span>OEM Component & Service Labor</span>
              <strong>₹{amount}</strong>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, marginBottom: 6, color: '#10B981', fontWeight: 700 }}>
              <span>42-Point Diagnostic Inspection</span>
              <span>FREE</span>
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 12.5, color: '#10B981', fontWeight: 700 }}>
              <span>Doorstep Pickup & Return Dispatch</span>
              <span>FREE</span>
            </div>
            <div style={{ borderTop: '1px solid #E8ECEA', marginTop: 10, paddingTop: 10, display: 'flex', justifyContent: 'space-between', fontSize: 15, fontWeight: 900, color: '#003A26' }}>
              <span>Total Paid Post-Verification</span>
              <span>₹{amount}</span>
            </div>
          </div>

          {/* Digital Signature & Seal */}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <div style={{
                background: 'rgba(16, 185, 129, 0.1)',
                color: '#10B981',
                padding: '3px 8px',
                borderRadius: 6,
                fontSize: 9,
                fontWeight: 800,
                display: 'inline-block',
                marginBottom: 4,
              }}>
                ✓ DIGITALLY SIGNED & VERIFIED
              </div>
              <div style={{ fontSize: 12, fontWeight: 700, color: '#003A26' }}>QuickFix Lab QA Manager</div>
              <div style={{ fontSize: 10.5, color: '#5F6F67' }}>Bengaluru Class-100 Cleanroom</div>
            </div>
            <div style={{
              width: 54,
              height: 54,
              borderRadius: '50%',
              border: '1.5px solid #003A26',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: 8,
              fontWeight: 900,
              color: '#003A26',
              textAlign: 'center',
              lineHeight: 1.1,
            }}>
              QUICKFIX<br/>SEAL<br/>★
            </div>
          </div>
        </div>

        {/* Modal Actions */}
        <div style={{
          padding: '16px 24px',
          borderTop: '1px solid #E8ECEA',
          display: 'flex',
          gap: 12,
          backgroundColor: '#FFFFFF',
        }}>
          <button
            onClick={() => alert('Certificate link copied to clipboard!')}
            className="btn-secondary"
            style={{ flex: 1 }}
          >
            <Share2 size={16} />
            Share Certificate
          </button>
          <button
            onClick={() => alert('Downloading official GST-compliant tax invoice PDF...')}
            className="btn-primary"
            style={{ flex: 1 }}
          >
            <Download size={16} />
            Download PDF
          </button>
        </div>
      </div>
    </div>
  );
};
