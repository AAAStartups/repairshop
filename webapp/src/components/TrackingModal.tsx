import React, { useState, useEffect } from 'react';
import { X, CheckCircle2, RefreshCw, PhoneCall, FastForward, QrCode, Shield, ShieldCheck } from 'lucide-react';
import { apiClient } from '../api/client';

interface TrackingModalProps {
  isOpen: boolean;
  onClose: () => void;
  orderId: string;
  onOpenWarranty: (orderId: string, device: string, amount: number) => void;
}

export const TrackingModal: React.FC<TrackingModalProps> = ({
  isOpen,
  onClose,
  orderId,
  onOpenWarranty,
}) => {
  const [order, setOrder] = useState<any>(null);
  const [currentStageIndex, setCurrentStageIndex] = useState(3);
  const [isAdvancing, setIsAdvancing] = useState(false);
  const [showPayment, setShowPayment] = useState(false);

  const stages = [
    { title: 'Booking Confirmed', sub: 'Your doorstep repair ticket has been registered', time: '10:15 AM' },
    { title: 'Technician Assigned', sub: 'Senior Specialist assigned with anti-static kit', time: '10:30 AM' },
    { title: 'Device Picked Up & Sealed', sub: 'En route to authorized cleanroom lab in tamper pouch #TP-992', time: 'Live Now' },
    { title: 'Received at Central Cleanroom Lab', sub: 'Device unboxed under HD camera monitoring' },
    { title: '42-Point Diagnostic Scan', sub: 'Display, battery health, thermal & logic board test' },
    { title: 'Transparent Quote Shared', sub: 'Exact OEM parts and zero-advance quotation verified' },
    { title: 'Awaiting Customer Approval', sub: '1-tap approval in app before technician proceeds' },
    { title: 'Precision Repair in Cleanroom', sub: 'Original components installed with ESD protection' },
    { title: 'Post-Repair Quality Check', sub: 'Touch calibration, water-seal replacement & stress test' },
    { title: 'Packed with Warranty Certificate', sub: '180-day QuickFix guarantee certificate enclosed in box' },
    { title: 'Out for Return Delivery', sub: 'Executive arriving at your doorstep with repaired device' },
    { title: 'Doorstep Verification & Handover', sub: 'Inspect phone functionality with executive, pay post-check' },
  ];

  const loadTracking = async () => {
    const data = await apiClient.getOrderTrack(orderId);
    if (data) {
      setOrder(data);
      setCurrentStageIndex(data.currentStageIndex || 3);
    }
  };

  useEffect(() => {
    if (isOpen) {
      loadTracking();
    }
  }, [isOpen, orderId]);

  if (!isOpen) return null;

  const handleAdvance = async () => {
    setIsAdvancing(true);
    await apiClient.advanceOrderStage(orderId);
    await loadTracking();
    setCurrentStageIndex((prev) => Math.min(prev + 1, 12));
    setIsAdvancing(false);
  };

  const deviceName = order?.device || 'Apple iPhone 15 Pro';
  const totalAmount = order?.totalAmount || 3899;

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
        maxWidth: 700,
        maxHeight: '92vh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
        boxShadow: '0 24px 60px rgba(0, 58, 38, 0.25)',
      }}>
        {/* Header */}
        <div style={{
          padding: '18px 24px',
          borderBottom: '1px solid #E8ECEA',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: 18, fontWeight: 900, color: '#003A26' }}>Live Repair Radar Tracker</div>
            <div style={{ fontSize: 12, color: '#5F6F67' }}>Service Order Ticket #{orderId}</div>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <button
              onClick={loadTracking}
              style={{
                background: '#F3F6F4',
                border: 'none',
                borderRadius: 10,
                width: 36,
                height: 36,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#003A26',
              }}
            >
              <RefreshCw size={16} />
            </button>
            <button
              onClick={onClose}
              style={{
                background: '#F3F6F4',
                border: 'none',
                borderRadius: 10,
                width: 36,
                height: 36,
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#5F6F67',
              }}
            >
              <X size={18} />
            </button>
          </div>
        </div>

        {/* Scrollable Body */}
        <div style={{ padding: 24, overflowY: 'auto', flex: 1 }}>
          {/* Hero Radar Card */}
          <div style={{
            background: 'linear-gradient(135deg, #003A26, #080C0A)',
            borderRadius: 20,
            padding: 20,
            color: 'white',
            marginBottom: 16,
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
              <div style={{
                background: 'rgba(16, 185, 129, 0.2)',
                border: '1px solid #10B981',
                padding: '4px 10px',
                borderRadius: 20,
                fontSize: 10.5,
                fontWeight: 800,
                color: '#10B981',
                display: 'flex',
                alignItems: 'center',
                gap: 6,
              }}>
                <div style={{ width: 6, height: 6, borderRadius: '50%', backgroundColor: '#10B981' }} className="pulse-dot" />
                STAGE {currentStageIndex} OF 12 • LIVE RADAR
              </div>
              <div style={{ fontSize: 11, color: '#EDB000', fontWeight: 700 }}>₹50K Insured Transit</div>
            </div>

            <div style={{ fontSize: 20, fontWeight: 900 }}>
              {stages[currentStageIndex - 1]?.title}
            </div>
            <div style={{ fontSize: 12.5, color: 'rgba(255,255,255,0.8)', marginTop: 4 }}>
              {stages[currentStageIndex - 1]?.sub}
            </div>

            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginTop: 16,
              paddingTop: 12,
              borderTop: '1px solid rgba(255,255,255,0.1)',
              fontSize: 13,
            }}>
              <span>{deviceName}</span>
              <strong style={{ color: '#EDB000' }}>₹{totalAmount} (Zero Advance)</strong>
            </div>
          </div>

          {/* Assigned Technician Card */}
          <div style={{
            backgroundColor: 'white',
            border: '1px solid #E8ECEA',
            borderRadius: 16,
            padding: 14,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            marginBottom: 16,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{
                width: 44,
                height: 44,
                borderRadius: 12,
                backgroundColor: '#003A26',
                color: '#EDB000',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 20,
              }}>
                👨‍🔧
              </div>
              <div>
                <div style={{ fontSize: 14, fontWeight: 800, color: '#003A26' }}>
                  Rajesh Kannan <span style={{ fontSize: 10, color: '#10B981', fontWeight: 700 }}>✓ CERTIFIED</span>
                </div>
                <div style={{ fontSize: 11.5, color: '#5F6F67' }}>
                  KA-03-QF-9081 EV • 4.96 ★ (412+ Jobs)
                </div>
              </div>
            </div>
            <button
              onClick={() => alert('Calling Executive Rajesh Kannan (+91 99887 76655)...')}
              style={{
                backgroundColor: '#003A26',
                color: 'white',
                border: 'none',
                borderRadius: 10,
                width: 38,
                height: 38,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: 'pointer',
              }}
            >
              <PhoneCall size={16} />
            </button>
          </div>

          {/* Interactive Simulation Bar */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginBottom: 20 }}>
            <button
              disabled={isAdvancing}
              onClick={handleAdvance}
              className="btn-secondary"
              style={{ fontSize: 12.5, padding: '10px 14px' }}
            >
              <FastForward size={16} color="#003A26" />
              {isAdvancing ? 'Advancing...' : 'Advance Stage ⏩'}
            </button>

            <button
              onClick={() => setShowPayment(true)}
              className="btn-primary"
              style={{ fontSize: 12.5, padding: '10px 14px' }}
            >
              <QrCode size={16} />
              Doorstep Payment
            </button>
          </div>

          {/* 12-Stage Visual Stepper */}
          <div style={{ border: '1px solid #E8ECEA', borderRadius: 20, padding: '18px 20px', backgroundColor: 'white' }}>
            <div style={{ fontSize: 13, fontWeight: 800, color: '#003A26', marginBottom: 16 }}>
              Complete 12-Stage Cleanroom Lifecycle
            </div>

            <div style={{ display: 'flex', flexDirection: 'column' }}>
              {stages.map((st, i) => {
                const stageIndex = i + 1;
                const isDone = stageIndex < currentStageIndex;
                const isActive = stageIndex === currentStageIndex;
                const isLast = i === stages.length - 1;

                return (
                  <div key={i} style={{ display: 'flex', gap: 14 }}>
                    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                      <div style={{
                        width: 28,
                        height: 28,
                        borderRadius: '50%',
                        backgroundColor: isDone ? '#003A26' : isActive ? '#EDB000' : '#F3F6F4',
                        color: isDone ? 'white' : isActive ? '#003A26' : '#94A3B8',
                        border: isDone ? 'none' : isActive ? '2px solid #003A26' : '1px solid #CBD5E1',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        fontSize: 11,
                        fontWeight: 800,
                      }}>
                        {isDone ? <CheckCircle2 size={16} /> : stageIndex}
                      </div>
                      {!isLast && (
                        <div style={{
                          width: 2,
                          flex: 1,
                          minHeight: 28,
                          backgroundColor: isDone ? '#003A26' : '#E8ECEA',
                          margin: '2px 0',
                        }} />
                      )}
                    </div>

                    <div style={{ paddingBottom: isLast ? 0 : 16, flex: 1 }}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{
                          fontSize: 13,
                          fontWeight: isActive || isDone ? 800 : 500,
                          color: isActive ? '#003A26' : isDone ? '#003A26' : '#5F6F67',
                        }}>
                          {stageIndex}. {st.title}
                        </span>
                        {st.time && (
                          <span style={{ fontSize: 11, color: isActive ? '#10B981' : '#94A3B8', fontWeight: 600 }}>
                            {st.time}
                          </span>
                        )}
                      </div>
                      <div style={{ fontSize: 11.5, color: '#5F6F67', marginTop: 2, lineHeight: 1.4 }}>
                        {st.sub}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Doorstep Payment Sheet Overlay */}
        {showPayment && (
          <div style={{
            position: 'absolute',
            inset: 0,
            backgroundColor: 'rgba(8, 12, 10, 0.85)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: 20,
            zIndex: 10,
          }}>
            <div style={{
              backgroundColor: 'white',
              borderRadius: 24,
              padding: 24,
              maxWidth: 440,
              width: '100%',
              textAlign: 'center',
            }}>
              <div style={{ fontSize: 18, fontWeight: 900, color: '#003A26' }}>Doorstep Post-Service Payment</div>
              <div style={{ fontSize: 12, color: '#5F6F67', marginTop: 4 }}>Zero Advance • Pay only after verifying phone</div>

              <div style={{
                margin: '20px auto',
                padding: 16,
                backgroundColor: 'white',
                border: '2px solid #EDB000',
                borderRadius: 20,
                width: 220,
                height: 220,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
              }}>
                <div style={{ fontSize: 120 }}>📱</div>
                <div style={{ fontSize: 11, fontWeight: 700, color: '#003A26' }}>Scan with GPay / PhonePe / Paytm</div>
              </div>

              <div style={{ fontSize: 24, fontWeight: 900, color: '#003A26', marginBottom: 16 }}>
                ₹{totalAmount}
              </div>

              <div style={{ display: 'flex', gap: 10 }}>
                <button
                  onClick={() => setShowPayment(false)}
                  className="btn-secondary"
                  style={{ flex: 1 }}
                >
                  Close
                </button>
                <button
                  onClick={() => {
                    setShowPayment(false);
                    onOpenWarranty(orderId, deviceName, totalAmount);
                  }}
                  className="btn-primary"
                  style={{ flex: 2 }}
                >
                  Simulate Payment ✓
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
