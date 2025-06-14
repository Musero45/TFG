function [etaMrp,etaMra,etaM] = getEtaM(transmission,etaRa)

etaTra         = transmission.etaTra;
etaTrp         = transmission.etaTrp;

etaMra         = 1/(1-etaTra);
etaMrp         = 1/(1-etaTrp);
etaM           = etaRa*etaMra + etaMrp;