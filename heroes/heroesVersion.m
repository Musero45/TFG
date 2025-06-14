function version = heroesVersion
%  HEROESVERSION Outputs the current version number of HEROES toolbox
%     
%  HISTORY OF VERSIONS (ARCHEOLOGY)
%
%  version = '0.0.0 (R2009a)';
%  Release date November 2009
%  heroes was born as a copy of earlier developments at Sevilla University
%  and the previous toolbox name was heToolBox
%
%  version = '0.0.1 (R2010a)';
%  Release date January 2010
%  First svn release of heroes 
%
%
%  version = '0.0.2 (R2011a)'; Nano major developments
%  version = '0.0.3 (R2012a)'; Emory, et. al.
%  version = '0.0.4 (R2013a)'; Iker
%
%  version = '1.0.0 (R2014a)'; 2013-2014
%  Released date January 15th 2014
%
%  version = '1.0.1 (R2014b)';
%  Released date March 10th 2014
%  New features:
%  * Energy method rewritten by Cesar Garcia
%  * dimensioning functions converted to IS units
%  * Big update of the chain from design requirements to statistical 
%    helicopter to energy helicopter. 
%  * Update of the engine database to use IS units 
%    together with the new functionality added by engine performance 
%    function handles
%
%  version = '1.0.2 (R2014c)';
%  Released date March 11th 2014
%  svn revision number 187
%  Bug fixes:
%  * some bug fixing in dimensioning functions
%  * added missing functions of dimensioning in IS units
%
%  version = '1.0.3 (R2014d)';
%  Released date March 31th 2014
%  svn revision number 214
%  Bug fixes:
%  * energy tests are right now fixed
%  * some bugs fixing in energy functions
%  * added the 115 engines to the database. Big thanks to all the students
%    of PFC 2013/2014:
%    Ivan, Marina, Sergio, Alejandro, Raquel, Hector, Maria, Sergio,
%    Cesar, Alvaro, Francisco, Lucia, Rocio y Jose Maria.
%  * Mayor developments in the QFD module by Cesar Garcia
%  * Some fixes and improvements to mission module: PL diagram
%  * Some improvements to energy module: getFlightEnvelope
%
%  version = '1.0.4 (R2014e)';
%  Released date April 22th 2014
%  svn revision number 228
%  Added new features:
%  * hFzero and vFzero options to energyoptions
%  * flight envelope structure definition
%  * excessPower function
%  * some work to make more robust getFlightEnvelope (branch definition)
%  * some work on trim (added trimPFCnano to trim tester)
%  * many comments to help documentation
%  * new desreq rescue6000kgDR
%  * some work on QFD module by Cesar Garcia, Hector y Sergio
%  * new Overal Evaluation Criteria OEC module by Cesar Garcia
%
%  version = '1.0.5 (R2014f)';
%  Released date April 28th 2014
%  svn revision number 237
%  Added new features:
%  * Statistical fit of equivalent flat plate area following Prouty scheme
%  of low|average|high drag fuselage
%  * statistical fit of inertia moments depending on MTOW
%  * documentation of debugging process for energy flight envelope using
%  getExcessPower and plotHelicopterEnginePerformance
%  * some work on test to compare power curve computed by energy method
%  versus trim method
%  * some work on OEC to include mission fuel calculation, configure
%  restrictions, adding performance automatically
%
%  version = '1.0.6 (R2014g)';
%  Released date May 5th 2015
%  svn revision number 442
%  beta version for mission caculation (PIE, Irene)
%  beta version of energy, trim and stability calculations
%
%  version = '1.0.6.1 (R2014h)';
%  Released date May 20th 2015
%  svn revision number 445
%  minor bug fixed related to Dani and Enrique's work
%
%  version = '1.1.0 (R2015a)';
%  Released date Sept 15th 2015
%  svn revision number 456
%  Version issued for Helicopters-MUIA 2015-2016
%
%  version = '1.1.1 (R2015a)';
%  Released date September 21th 2015
%  svn revision number 463
%  Some minor updates to getISA and plotISA just to follow the standard of
%  options and plots.
%
%  version = '1.1.2 (R2016a)';
%
%  Released data Sep 20th 2016 (moodle HE.MUIA
%  svn version 499
%  Non linear flight dynamics (Arturo) Gazelle (Fran),
%  new rigidHe2ndHe(he,atm,H)
% 
%  Released data Octuber 3rd 2017 (arya upload)
%  First release under GNU GPL3 or later 
%  Added COPYING file with GNU GPL2 and replaced by the current GPL3
%  svn version 507 
%  No major improvements from previous version
%
%  version = '1.2.0 (R2017a)';
%
%  Released data:
%  April 19th 2018 (uploaded to dca moodle and HE-MUIA moodle)
%  May 8th (uploaded to arya)
%  Added functions to obtain a rigid helicopter from another rigid
%  helicopter by using dimensional analysis.
%  Added functions to modify the inertia and geometry fields of a rigid he
%  by adding a payload with known inertia properties
%  See heroresTest\dimensioning\dimensionin06.m and heroresTest\dimensioning\dimensionin07.m 
%  svn version 508 
%  
%  version = '1.2.0 (R2018a)';
%
%
%  Released data:
%  September 05th 2022 (uploaded to dca moodle and HE-MUIA moodle)
%  May 8th (uploaded to arya)
%  Minor modifications
%  svn version 518

version = '1.2.1 (R2022a)';

% HERE WE XHOULD ADD ITEMS DESCRIBING PROGRESS FROM THIS VERSION
%
%

