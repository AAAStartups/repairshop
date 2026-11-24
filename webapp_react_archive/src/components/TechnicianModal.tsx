import React, { useState } from 'react';
import { X, Wrench, CheckCircle2, QrCode, Navigation, PhoneCall } from 'lucide-react';
import { apiClient } from '../api/client';

interface TechnicianModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const TechnicianModal: React.FC<TechnicianModalProps> = ({ isOpen, onClose }) => {
  const [isOnline, setIsOnline] = useState(true);
  const [pouchScanned, setPouchScanned] = useState(true);
  const [diagnosticChecks, setDiagnosticChecks] = useState<Record<string, boolean>>({
    'OLED Screen Digitizer & Multi-Touch (10-Point)': true,
    'TrueTone & Ambient Light Calibration': true,
    'FaceID / Biometric Fingerprint Sensor': true,
    'Battery Health Capacity & Thermal Probe': true,
    'Type-C Fast Charging Sub-Board (9V/2A)': true,
    'Rear Primary Camera OIS & 4K Video Focus': true,
    'Front TrueDepth Selfie Camera & Mic': true,
    'Stereo Dual Speakers & Earpiece Decibel': true,
    'Acoustic Waterproofing Perimeter Seal': true,
  });

  if (!isOpen) return null;

  const toggleCheck = (key: string) => {
    setDiagnosticChecks((prev) => ({ ...prev, [key]: !prev[key] }));
  };

  const handleCompleteStage = async () => {
    await apiClient.advanceOrderStage('QF-89421');
    alert('✅ Doorstep pickup confirmed! Device sealed in tamper bag TP-9924-BLR and dispatched to lab.');
    onClose();
  };

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
      }}>
        {/* Header */}
        <div style={{
          backgroundColor: '#003A26',
          color: 'white',
          padding: '18px 24px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: 17, fontWeight: 900 }}>Technician Operations Hub</div>
            <div style={{ fontSize: 11, color: '#EDB000' }}>Rajesh Kannan • Field Specialist ID #QF-T881</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <span style={{ fontSize: 11, fontWeight: 800, color: isOnline ? '#10B981' : '#94A3B8' }}>
              {isOnline ? 'ONLINE' : 'OFFLINE'}
            </span>
            <input
              type="checkbox"
              checked={isOnline}
              onChange={(e) => setIsOnline(e.target.checked)}
              style={{ width: 18, height: 18, accentColor: '#10B981', cursor: 'pointer' }}
            />
            <button
              onClick={onClose}
              style={{
                background: 'rgba(255,255,255,0.15)',
                border: 'none',
                borderRadius: 8,
                width: 32,
                height: 32,
                cursor: 'pointer',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <X size={16} />
            </button>
          </div>
        </div>

        {/* Scrollable Content */}
        <div style={{ padding: 24, overflowY: 'auto', flex: 1 }}>
          {/* Active Job Card */}
          <div style={{
            border: '2px solid #EDB000',
            borderRadius: 18,
            padding: 18,
            marginBottom: 16,
            backgroundColor: '#F8FAF9',
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
              <span style={{ backgroundColor: '#003A26', color: 'white', fontSize: 11, fontWeight: 800, padding: '3px 8px', borderRadius: 6 }}>
                ACTIVE DISPATCH • QF-89421
              </span>
              <span style={{ fontSize: 11.5, fontWeight: 600, color: '#5F6F67' }}>Slot: 10:00 - 12:00 PM</span>
            </div>

            <div style={{ fontSize: 16, fontWeight: 900, color: '#003A26' }}>Arjun Verma (+91 98765 43210)</div>
            <div style={{ fontSize: 12.5, color: '#5F6F67', marginTop: 2 }}>
              #402, Green Glen Layout, Outer Ring Road, Bellandur, Bengaluru - 560103
            </div>

            <div style={{
              backgroundColor: 'white',
              border: '1px solid #E8ECEA',
              padding: 10,
              borderRadius: 12,
              marginTop: 10,
              fontSize: 12,
              fontWeight: 700,
              color: '#003A26',
            }}>
              📱 Apple iPhone 15 Pro • OEM Screen & Digitizer
            </div>

            <div style={{ display: 'flex', gap: 10, marginTop: 12 }}>
              <button
                onClick={() => alert('Launching Google Maps turn-by-turn navigation...')}
                className="btn-primary"
                style={{ flex: 1, padding: '9px 12px', fontSize: 12 }}
              >
                <Navigation size={14} />
                Navigate
              </button>
              <button
                onClick={() => alert('Calling customer Arjun Verma...')}
                className="btn-secondary"
                style={{ padding: '9px 12px', fontSize: 12 }}
              >
                <PhoneCall size={14} />
                Call
              </button>
            </div>
          </div>

          {/* Tamper Pouch Scanner */}
          <div style={{ border: '1px solid #E8ECEA', borderRadius: 16, padding: 16, marginBottom: 16 }}>
            <div style={{ fontSize: 13, fontWeight: 800, color: '#003A26', marginBottom: 4 }}>
              Tamper-Proof Pouch Verification
            </div>
            <div style={{ fontSize: 11.5, color: '#5F6F67', marginBottom: 12 }}>
              Scan the high-grade security barcode bag in customer presence.
            </div>

            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <div style={{ fontSize: 13, fontWeight: 800, color: '#003A26', backgroundColor: '#F3F6F4', padding: '8px 12px', borderRadius: 8 }}>
                Barcode: TP-9924-BLR
              </div>
              <button
                onClick={() => setPouchScanned(true)}
                className="btn-primary"
                style={{
                  backgroundColor: pouchScanned ? '#10B981' : '#EDB000',
                  color: pouchScanned ? 'white' : '#003A26',
                  padding: '8px 14px',
                  fontSize: 11.5,
                }}
              >
                {pouchScanned ? '✓ SEAL VALIDATED' : 'SCAN POUCH'}
              </button>
            </div>
          </div>

          {/* 42-Point Diagnostic Checklist */}
          <div style={{ border: '1px solid #E8ECEA', borderRadius: 16, padding: 16 }}>
            <div style={{ fontSize: 13, fontWeight: 800, color: '#003A26', marginBottom: 4 }}>
              42-Point Diagnostic Checklist
            </div>
            <div style={{ fontSize: 11.5, color: '#5F6F67', marginBottom: 12 }}>
              Record initial hardware health checklist before lab transport:
            </div>

            {Object.entries(diagnosticChecks).map(([name, checked]) => (
              <div
                key={name}
                onClick={() => toggleCheck(name)}
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  padding: '8px 0',
                  borderBottom: '1px solid #F3F6F4',
                  fontSize: 12.5,
                  cursor: 'pointer',
                }}
              >
                <span>{name}</span>
                <input
                  type="checkbox"
                  checked={checked}
                  onChange={() => toggleCheck(name)}
                  style={{ width: 16, height: 16, accentColor: '#10B981' }}
                />
              </div>
            ))}
          </div>
        </div>

        {/* Footer */}
        <div style={{ padding: '16px 24px', borderTop: '1px solid #E8ECEA' }}>
          <button
            onClick={handleCompleteStage}
            className="btn-primary"
            style={{ width: '100%', padding: '14px', fontSize: 14 }}
          >
            Complete Stage & Seal in Tamper Pouch ✓
          </button>
        </div>
      </div>
    </div>
  );
};
