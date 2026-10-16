function[AO_info] = construct_AO_info(coordfile,basisfile)

%{
Author: JCW(09/10/2026)
- Map coordinate and atomic basis (inc. angular component) info to the AOs for each MO.
- AO ordering is consistent for all MOs!
%}

  % Load coordinate file extracted from MOLDEN
  if ischar(coordfile) == 1
    coord = importdata(coordfile);
  else
    coord = coordfile;
  end

  % Generate info for each AO
  AO_info.pos_ind = []; % Atom index in coordinate file
  AO_info.l = [];       % Orbital angular momentum
  AO_info.m = [];       % Magnetic quantum number
  AO_info.cG = [];      % Contracted Gaussian file to read
  for i=1:size(coord,1)
    elem = get_elementsymbol(coord(i,2)); % Generate element symbol for array variable name
    for j = 1:length(basisfile.(elem).l)
      AO_info.pos_ind = cat(1,AO_info.pos_ind,i);
    end
    AO_info.l = cat(1,AO_info.l,basisfile.(elem).l);
    AO_info.m = cat(1,AO_info.m,basisfile.(elem).m);
    AO_info.cG = cat(1,AO_info.cG,basisfile.(elem).cG);
  end
end
