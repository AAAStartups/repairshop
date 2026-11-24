import React, { useState, useEffect } from 'react';
import { X, ArrowLeft, CheckCircle2, Shield, MapPin, Calendar, Clock, Sparkles } from 'lucide-react';
import { Brand, DeviceModel, RepairService, apiClient } from '../api/client';

interface BookingModalProps {
  isOpen: boolean;
  onClose: () => void;
  onBookingSuccess: (bookingId: string) => void;
}

export const BookingModal: React.FC<BookingModalProps> = ({ isOpen, onClose, onBookingSuccess }) => {
  const [step, setStep] = useState<number>(1);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [models, setModels] = useState<DeviceModel[]>([]);
  const [repairs, setRepairs] = useState<RepairService[]>([]);
  
  // Selection states
  const [selectedBrand, setSelectedBrand] = useState<Brand | null>(null);
  const [selectedModel, setSelectedModel] = useState<DeviceModel | null>(null);
  const [selectedRepairs, setSelectedRepairs] = useState<RepairService[]>([]);
  
  // Address form
  const [flat, setFlat] = useState('#402, Green Glen Layout');
  const [street, setStreet] = useState('Outer Ring Road, Bellandur');
  const [city, setCity] = useState('Bengaluru');
  const [pincode, setPincode] = useState('560103');
  const [isLocating, setIsLocating] = useState(false);

  // Scheduling
  const [selectedDate, setSelectedDate] = useState('Today');
  const [selectedSlot, setSelectedSlot] = useState('10:00 AM - 12:00 PM');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (isOpen) {
      apiClient.getBrands().then(setBrands);
    }
  }, [isOpen]);

  useEffect(() => {
    if (selectedBrand) {
      apiClient.getModels(selectedBrand.slug).then(setModels);
    }
  }, [selectedBrand]);

  useEffect(() => {
    if (selectedModel) {
      apiClient.getRepairs(selectedModel.id).then(setRepairs);
    }
  }, [selectedModel]);

  if (!isOpen) return null;

  const totalCost = selectedRepairs.reduce((acc, curr) => acc + curr.price, 0);

  const toggleRepair = (r: RepairService) => {
    if (selectedRepairs.some((item) => item.id === r.id)) {
      setSelectedRepairs(selectedRepairs.filter((item) => item.id !== r.id));
    } else {
      setSelectedRepairs([...selectedRepairs, r]);
    }
  };

  const handleDetectLocation = () => {
    setIsLocating(true);
    if ('geolocation' in navigator) {
      navigator.geolocation.getCurrentPosition(
        () => {
          setTimeout(() => {
            setIsLocating(false);
            setStreet('100 Feet Road, Indiranagar');
            setCity('Bengaluru');
            setPincode('560038');
            alert('📍 GPS Lock acquired: Indiranagar, Bengaluru (560038) • Active cleanroom hub');
          }, 800);
        },
        () => {
          setIsLocating(false);
          alert('GPS permission prompt denied. Using Bengaluru hub fallback.');
        }
      );
    } else {
      setIsLocating(false);
    }
  };

  const handleConfirmBooking = async () => {
    setIsSubmitting(true);
    const result = await apiClient.createBooking({
      deviceModelId: selectedModel?.id || 'iphone-15-pro',
      repairServiceIds: selectedRepairs.map((r) => r.id),
      scheduledDate: new Date().toISOString(),
      timeSlot: selectedSlot,
      address: {
        label: 'Home',
        addressLine1: `${flat}, ${street}`,
        city,
        state: 'Karnataka',
        postalCode: pincode,
      },
    });

    setIsSubmitting(false);
    if (result.success) {
      onClose();
      onBookingSuccess(result.bookingNumber);
    }
  };

  const stepTitles = [
    'Choose Brand',
    'Select Model',
    'Pick Services',
    'Pickup Address',
    'Schedule Slot',
    'Review Order',
  ];

  return (
    <div style={{
      position: 'fixed',
      inset: 0,
      backgroundColor: 'rgba(8, 12, 10, 0.75)',
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
        maxWidth: 720,
        maxHeight: '90vh',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
        boxShadow: '0 24px 60px rgba(0, 58, 38, 0.25)',
      }}>
        {/* Modal Header */}
        <div style={{
          padding: '16px 24px',
          borderBottom: '1px solid #E8ECEA',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          backgroundColor: '#FFFFFF',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            {step > 1 && (
              <button
                onClick={() => setStep(step - 1)}
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
                <ArrowLeft size={16} />
              </button>
            )}
            <div>
              <div style={{ fontSize: 17, fontWeight: 800, color: '#003A26' }}>
                {stepTitles[step - 1]}
              </div>
              <div style={{ fontSize: 11.5, color: '#5F6F67', fontWeight: 600 }}>
                Step {step} of 6 • Zero Advance Payment Guarantee
              </div>
            </div>
          </div>
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

        {/* Step Progress Pill Rail */}
        <div style={{ display: 'flex', padding: '12px 24px', gap: 6, backgroundColor: '#F8FAF9', borderBottom: '1px solid #E8ECEA' }}>
          {[1, 2, 3, 4, 5, 6].map((s) => (
            <div
              key={s}
              style={{
                flex: 1,
                height: 4,
                borderRadius: 2,
                backgroundColor: s <= step ? '#003A26' : '#E8ECEA',
                transition: 'background-color 0.3s',
              }}
            />
          ))}
        </div>

        {/* Modal Scrollable Content */}
        <div style={{ padding: 24, overflowY: 'auto', flex: 1 }}>
          {/* STEP 1: BRAND SELECTION */}
          {step === 1 && (
            <div>
              <div style={{ fontSize: 13, color: '#5F6F67', marginBottom: 16 }}>
                Select your smartphone or device manufacturer for verified OEM component matching:
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(130px, 1fr))', gap: 14 }}>
                {brands.map((b) => {
                  const isSelected = selectedBrand?.id === b.id;
                  return (
                    <div
                      key={b.id}
                      onClick={() => {
                        setSelectedBrand(b);
                        setStep(2);
                      }}
                      style={{
                        padding: '18px 12px',
                        borderRadius: 18,
                        border: isSelected ? '2px solid #EDB000' : '1px solid #E8ECEA',
                        backgroundColor: isSelected ? '#003A26' : '#FFFFFF',
                        color: isSelected ? '#FFFFFF' : '#003A26',
                        textAlign: 'center',
                        cursor: 'pointer',
                        transition: 'all 0.2s',
                        boxShadow: '0 2px 6px rgba(0,0,0,0.02)',
                      }}
                    >
                      <div style={{ fontSize: 32, marginBottom: 8 }}>
                        {b.name === 'Apple' ? '🍎' : b.name === 'Samsung' ? '📱' : b.name === 'OnePlus' ? '🔴' : b.name === 'Xiaomi' ? '⬛' : b.name.includes('Pixel') ? '🌈' : '📲'}
                      </div>
                      <div style={{ fontSize: 13, fontWeight: 700 }}>{b.name}</div>
                      <div style={{ fontSize: 10, color: isSelected ? '#EDB000' : '#10B981', marginTop: 4, fontWeight: 600 }}>
                        OEM Parts ✓
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* STEP 2: MODEL SELECTION */}
          {step === 2 && (
            <div>
              <div style={{ fontSize: 13, color: '#5F6F67', marginBottom: 16 }}>
                Choose your specific <strong>{selectedBrand?.name}</strong> model:
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(190px, 1fr))', gap: 12 }}>
                {models.map((m) => {
                  const isSelected = selectedModel?.id === m.id;
                  return (
                    <div
                      key={m.id}
                      onClick={() => {
                        setSelectedModel(m);
                        setStep(3);
                      }}
                      style={{
                        padding: 16,
                        borderRadius: 16,
                        border: isSelected ? '2px solid #EDB000' : '1px solid #E8ECEA',
                        backgroundColor: isSelected ? '#003A26' : '#FFFFFF',
                        color: isSelected ? '#FFFFFF' : '#003A26',
                        cursor: 'pointer',
                        transition: 'all 0.2s',
                      }}
                    >
                      <div style={{ fontSize: 11, color: isSelected ? '#EDB000' : '#5F6F67', fontWeight: 700 }}>
                        {m.series}
                      </div>
                      <div style={{ fontSize: 14, fontWeight: 800, margin: '4px 0 8px 0' }}>
                        {m.name}
                      </div>
                      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                        <span style={{ fontSize: 11, color: isSelected ? 'white' : '#5F6F67' }}>{m.releaseYear}</span>
                        <span className="badge-oem" style={{ fontSize: 10, padding: '2px 6px' }}>OEM Stocked</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* STEP 3: REPAIR SERVICES */}
          {step === 3 && (
            <div>
              <div style={{ fontSize: 13, color: '#5F6F67', marginBottom: 16 }}>
                Select one or more services needed for your <strong>{selectedModel?.name}</strong>:
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                {repairs.map((r) => {
                  const isSelected = selectedRepairs.some((item) => item.id === r.id);
                  return (
                    <div
                      key={r.id}
                      onClick={() => toggleRepair(r)}
                      style={{
                        padding: 16,
                        borderRadius: 18,
                        border: isSelected ? '2px solid #003A26' : '1px solid #E8ECEA',
                        backgroundColor: isSelected ? '#F8FAF9' : '#FFFFFF',
                        cursor: 'pointer',
                        display: 'flex',
                        alignItems: 'flex-start',
                        justifyContent: 'space-between',
                        gap: 16,
                      }}
                    >
                      <div style={{ flex: 1 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                          <span style={{ fontSize: 14, fontWeight: 800, color: '#003A26' }}>{r.title}</span>
                          {r.badge && (
                            <span style={{ backgroundColor: '#EDB000', color: '#003A26', fontSize: 10, padding: '2px 6px', borderRadius: 6, fontWeight: 800 }}>
                              {r.badge}
                            </span>
                          )}
                        </div>
                        <div style={{ fontSize: 12, color: '#5F6F67', lineHeight: 1.4 }}>{r.description}</div>
                        <div style={{ display: 'flex', gap: 12, marginTop: 8, fontSize: 11, color: '#003A26', fontWeight: 600 }}>
                          <span>⏱ {r.turnaroundMinutes / 60} hrs turnaround</span>
                          <span>🛡️ {r.warrantyDays / 30} months warranty</span>
                        </div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <div style={{ fontSize: 16, fontWeight: 900, color: '#003A26' }}>₹{r.price}</div>
                        <div style={{
                          marginTop: 6,
                          width: 24,
                          height: 24,
                          borderRadius: 8,
                          backgroundColor: isSelected ? '#003A26' : '#FFFFFF',
                          border: isSelected ? 'none' : '1.5px solid #CBD5E1',
                          display: 'inline-flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          color: '#FFFFFF',
                        }}>
                          {isSelected && <CheckCircle2 size={16} />}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* STEP 4: PICKUP ADDRESS & GPS */}
          {step === 4 && (
            <div>
              {/* GPS Auto-Detect Button */}
              <div
                onClick={handleDetectLocation}
                style={{
                  padding: 16,
                  borderRadius: 18,
                  background: 'linear-gradient(90deg, rgba(0,58,38,0.08), rgba(237,176,0,0.12))',
                  border: '1px solid rgba(0,58,38,0.2)',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 14,
                  marginBottom: 18,
                }}
              >
                <div style={{
                  width: 44,
                  height: 44,
                  borderRadius: 14,
                  backgroundColor: '#003A26',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: '#EDB000',
                }}>
                  <MapPin size={22} />
                </div>
                <div>
                  <div style={{ fontSize: 14, fontWeight: 800, color: '#003A26' }}>
                    {isLocating ? 'Acquiring GPS fix...' : 'Use Current GPS Location'}
                  </div>
                  <div style={{ fontSize: 11.5, color: '#5F6F67' }}>
                    Auto-fill doorstep street, area and 6-digit postal code
                  </div>
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                <div>
                  <label style={{ fontSize: 12, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 4 }}>
                    FLAT / BUILDING / PREMISES
                  </label>
                  <input
                    type="text"
                    value={flat}
                    onChange={(e) => setFlat(e.target.value)}
                    style={{
                      width: '100%',
                      padding: '12px 14px',
                      borderRadius: 12,
                      border: '1px solid #E8ECEA',
                      backgroundColor: '#F8FAF9',
                      fontSize: 13,
                      fontWeight: 600,
                    }}
                  />
                </div>
                <div>
                  <label style={{ fontSize: 12, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 4 }}>
                    STREET ADDRESS & LOCALITY
                  </label>
                  <input
                    type="text"
                    value={street}
                    onChange={(e) => setStreet(e.target.value)}
                    style={{
                      width: '100%',
                      padding: '12px 14px',
                      borderRadius: 12,
                      border: '1px solid #E8ECEA',
                      backgroundColor: '#F8FAF9',
                      fontSize: 13,
                      fontWeight: 600,
                    }}
                  />
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                  <div>
                    <label style={{ fontSize: 12, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 4 }}>
                      CITY
                    </label>
                    <input
                      type="text"
                      value={city}
                      onChange={(e) => setCity(e.target.value)}
                      style={{
                        width: '100%',
                        padding: '12px 14px',
                        borderRadius: 12,
                        border: '1px solid #E8ECEA',
                        backgroundColor: '#F8FAF9',
                        fontSize: 13,
                        fontWeight: 600,
                      }}
                    />
                  </div>
                  <div>
                    <label style={{ fontSize: 12, fontWeight: 700, color: '#5F6F67', display: 'block', marginBottom: 4 }}>
                      POSTAL PINCODE
                    </label>
                    <input
                      type="text"
                      value={pincode}
                      onChange={(e) => setPincode(e.target.value)}
                      style={{
                        width: '100%',
                        padding: '12px 14px',
                        borderRadius: 12,
                        border: '1px solid #E8ECEA',
                        backgroundColor: '#F8FAF9',
                        fontSize: 13,
                        fontWeight: 600,
                      }}
                    />
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* STEP 5: SCHEDULING */}
          {step === 5 && (
            <div>
              <div style={{ fontSize: 13, color: '#5F6F67', marginBottom: 16 }}>
                Select doorstep pickup date and executive arrival window:
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 10, marginBottom: 20 }}>
                {['Today', 'Tomorrow', 'Day After', 'Weekend'].map((d) => (
                  <div
                    key={d}
                    onClick={() => setSelectedDate(d)}
                    style={{
                      padding: '14px 8px',
                      borderRadius: 14,
                      textAlign: 'center',
                      border: selectedDate === d ? '2px solid #003A26' : '1px solid #E8ECEA',
                      backgroundColor: selectedDate === d ? '#003A26' : '#FFFFFF',
                      color: selectedDate === d ? '#FFFFFF' : '#003A26',
                      cursor: 'pointer',
                      fontSize: 12.5,
                      fontWeight: 700,
                    }}
                  >
                    {d}
                  </div>
                ))}
              </div>

              <div style={{ fontSize: 13, fontWeight: 700, color: '#003A26', marginBottom: 12 }}>
                Preferred Arrival Window:
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {[
                  '10:00 AM - 12:00 PM (Morning Slot)',
                  '01:00 PM - 03:00 PM (Afternoon Slot)',
                  '04:00 PM - 06:00 PM (Evening Slot)',
                  '07:00 PM - 09:00 PM (Night Express Slot)',
                ].map((s) => (
                  <div
                    key={s}
                    onClick={() => setSelectedSlot(s)}
                    style={{
                      padding: 14,
                      borderRadius: 14,
                      border: selectedSlot === s ? '2px solid #EDB000' : '1px solid #E8ECEA',
                      backgroundColor: selectedSlot === s ? '#F8FAF9' : '#FFFFFF',
                      cursor: 'pointer',
                      fontSize: 13,
                      fontWeight: 700,
                      color: '#003A26',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'space-between',
                    }}
                  >
                    <span>{s}</span>
                    {selectedSlot === s && <CheckCircle2 size={16} color="#EDB000" />}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* STEP 6: REVIEW & CONFIRM */}
          {step === 6 && (
            <div>
              <div style={{
                background: 'linear-gradient(90deg, #003A26, #1F2D27)',
                color: 'white',
                padding: 18,
                borderRadius: 18,
                marginBottom: 18,
              }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <div style={{ fontSize: 16, fontWeight: 900 }}>{selectedBrand?.name} {selectedModel?.name}</div>
                    <div style={{ fontSize: 12, color: '#EDB000', marginTop: 2 }}>Zero Advance Payment Guaranteed</div>
                  </div>
                  <div style={{ fontSize: 24, fontWeight: 900, color: '#EDB000' }}>₹{totalCost}</div>
                </div>
              </div>

              <div style={{ border: '1px solid #E8ECEA', borderRadius: 16, padding: 16, marginBottom: 16 }}>
                <div style={{ fontSize: 12, fontWeight: 800, color: '#5F6F67', marginBottom: 10 }}>SELECTED REPAIRS</div>
                {selectedRepairs.map((r) => (
                  <div key={r.id} style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, marginBottom: 6 }}>
                    <span>{r.title}</span>
                    <strong>₹{r.price}</strong>
                  </div>
                ))}
                <div style={{ borderTop: '1px solid #E8ECEA', marginTop: 10, paddingTop: 10, display: 'flex', justifyContent: 'space-between', fontSize: 13, color: '#10B981', fontWeight: 700 }}>
                  <span>Doorstep Pickup & Return Dispatch</span>
                  <span>FREE</span>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, color: '#10B981', fontWeight: 700, marginTop: 4 }}>
                  <span>Class-100 Cleanroom Diagnostics</span>
                  <span>FREE</span>
                </div>
              </div>

              <div style={{ border: '1px solid #E8ECEA', borderRadius: 16, padding: 16 }}>
                <div style={{ fontSize: 12, fontWeight: 800, color: '#5F6F67', marginBottom: 8 }}>DISPATCH DETAILS</div>
                <div style={{ fontSize: 13, color: '#003A26', fontWeight: 600 }}>📍 {flat}, {street}, {city} - {pincode}</div>
                <div style={{ fontSize: 13, color: '#003A26', fontWeight: 600, marginTop: 4 }}>⏱ Arrival: {selectedDate} • {selectedSlot}</div>
              </div>
            </div>
          )}
        </div>

        {/* Modal Footer Bar */}
        <div style={{
          padding: '16px 24px',
          borderTop: '1px solid #E8ECEA',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          backgroundColor: '#FFFFFF',
        }}>
          <div>
            <div style={{ fontSize: 11, color: '#5F6F67', fontWeight: 700 }}>TOTAL ESTIMATE</div>
            <div style={{ fontSize: 18, fontWeight: 900, color: '#003A26' }}>
              {totalCost > 0 ? `₹${totalCost}` : 'Free Inspection'}
            </div>
          </div>

          <div>
            {step < 6 ? (
              <button
                disabled={(step === 1 && !selectedBrand) || (step === 2 && !selectedModel) || (step === 3 && selectedRepairs.length === 0)}
                onClick={() => setStep(step + 1)}
                className="btn-primary"
              >
                Continue →
              </button>
            ) : (
              <button
                disabled={isSubmitting}
                onClick={handleConfirmBooking}
                className="btn-primary"
                style={{ backgroundColor: '#10B981', color: 'white' }}
              >
                {isSubmitting ? 'Confirming Ticket...' : 'Confirm Doorstep Booking ✓'}
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
