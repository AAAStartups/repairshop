import React, { useState } from 'react';
import { X, Phone, KeyRound, CheckCircle2 } from 'lucide-react';
import { apiClient } from '../api/client';

interface AuthModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (phone: string) => void;
}

export const AuthModal: React.FC<AuthModalProps> = ({ isOpen, onClose, onSuccess }) => {
  const [phone, setPhone] = useState('+91 98765 43210');
  const [otp, setOtp] = useState('123456');
  const [step, setStep] = useState<'phone' | 'otp'>('phone');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleSendOtp = async () => {
    setIsLoading(true);
    setError(null);
    const success = await apiClient.sendOtp(phone);
    setIsLoading(false);
    if (success) {
      setStep('otp');
    } else {
      setError('Could not send OTP. Rate limit may apply.');
    }
  };

  const handleVerifyOtp = async () => {
    setIsLoading(true);
    setError(null);
    const res = await apiClient.verifyOtp(phone, otp);
    setIsLoading(false);
    if (res.success) {
      onSuccess(phone);
      onClose();
    } else {
      setError('Invalid OTP code. Try 123456 in dev mode.');
    }
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
        maxWidth: 440,
        overflow: 'hidden',
        boxShadow: '0 24px 60px rgba(0, 58, 38, 0.25)',
        padding: 28,
        position: 'relative',
      }}>
        <button
          onClick={onClose}
          style={{
            position: 'absolute',
            top: 16,
            right: 16,
            background: '#F3F6F4',
            border: 'none',
            borderRadius: 8,
            width: 32,
            height: 32,
            cursor: 'pointer',
            color: '#5F6F67',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <X size={16} />
        </button>

        <div style={{
          width: 50,
          height: 50,
          borderRadius: 14,
          backgroundColor: 'rgba(0, 58, 38, 0.08)',
          color: '#003A26',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          marginBottom: 16,
        }}>
          {step === 'phone' ? <Phone size={24} /> : <KeyRound size={24} />}
        </div>

        <div style={{ fontSize: 20, fontWeight: 900, color: '#003A26' }}>
          {step === 'phone' ? 'Sign In with Phone' : 'Enter 6-Digit OTP'}
        </div>
        <div style={{ fontSize: 13, color: '#5F6F67', marginTop: 4, marginBottom: 20 }}>
          {step === 'phone'
            ? 'Access your active repair tracking and 180-day warranty certificates.'
            : `We sent a verification code to ${phone}. Enter 123456.`}
        </div>

        {error && (
          <div style={{
            backgroundColor: '#FEE2E2',
            color: '#DC2626',
            padding: '10px 14px',
            borderRadius: 10,
            fontSize: 12,
            marginBottom: 16,
          }}>
            {error}
          </div>
        )}

        {step === 'phone' ? (
          <div>
            <label style={{ fontSize: 11, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 6 }}>
              MOBILE NUMBER
            </label>
            <input
              type="text"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              placeholder="+91 98765 43210"
              style={{
                width: '100%',
                padding: '12px 14px',
                borderRadius: 12,
                border: '1px solid #CBD5E1',
                fontSize: 14,
                fontWeight: 600,
                marginBottom: 20,
              }}
            />
            <button
              disabled={isLoading}
              onClick={handleSendOtp}
              className="btn-primary"
              style={{ width: '100%', padding: '13px' }}
            >
              {isLoading ? 'Sending Code...' : 'Send Verification OTP →'}
            </button>
          </div>
        ) : (
          <div>
            <label style={{ fontSize: 11, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 6 }}>
              VERIFICATION CODE
            </label>
            <input
              type="text"
              value={otp}
              onChange={(e) => setOtp(e.target.value)}
              maxLength={6}
              placeholder="123456"
              style={{
                width: '100%',
                padding: '12px 14px',
                borderRadius: 12,
                border: '1px solid #CBD5E1',
                fontSize: 20,
                letterSpacing: 6,
                fontWeight: 800,
                textAlign: 'center',
                marginBottom: 20,
              }}
            />
            <button
              disabled={isLoading}
              onClick={handleVerifyOtp}
              className="btn-primary"
              style={{ width: '100%', padding: '13px' }}
            >
              {isLoading ? 'Verifying...' : 'Verify & Continue ✓'}
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
