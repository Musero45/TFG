function [CPtransmission,CPtMr,CPtTr] = standardTransmission(CQmr,CQtr,rAngVel,transmission)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

etaTmr = transmission.etaTmr;
etaTtr = transmission.etaTtr;

CPtMr = etaTmr*abs(CQmr);
CPtTr = etaTtr*rAngVel*abs(CQtr);

CPtransmission = etaTmr*abs(CQmr)+etaTtr*rAngVel*abs(CQtr);

end

