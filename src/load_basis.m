function[basis] = load_basis(filename) 
%
%! Author: JCW(09/10/2026)
%! - Load basis set info file for a single atomic species from MOLDEN
%! - Implementation up to d-orbitals ONLY!
%

  % Read GTO basis file into a character vector
  fid = fopen(filename,'r');
  ch = fread(fid,[1,Inf],'*char');
  fclose(fid);
  % Split based on line endings
  str = regexp(ch,'\r?\n','split');
  % Count number of lines
  nlines = numel(str);
  % Find header lines containing the orbital type: 's','p','d', ...
  orb_s = strfind(str,'s');
  orb_p = strfind(str,'p');
  orb_d = strfind(str,'d');
  
  % Find header line corresponding to each contracted Gaussian
  % Then extract info on orbital type and number of primitive Gaussians
  header_line = []; % Header line
  orbtype = []; % Orbital type
  n_pG = []; % Number of primitive Gaussians
  tot_cG = 0; % Count total number of contracted Gaussians
  for i = 1:nlines
    if orb_s{i} == 1
      header_line = cat(1,header_line,i);
      iline = strsplit(str{i},' ');
      orbtype = cat(1,orbtype,iline{1});
      n_pG = cat(1,n_pG,str2num(iline{2}));
      tot_cG = tot_cG + 1;
    elseif orb_p{i} == 1
      header_line = cat(1,header_line,i);
      iline = strsplit(str{i},' ');
      orbtype = cat(1,orbtype,iline{1});
      n_pG = cat(1,n_pG,str2num(iline{2}));
      tot_cG = tot_cG + 1;
    elseif orb_d{i} == 1
      header_line = cat(1,header_line,i);
      iline = strsplit(str{i},' ');
      orbtype = cat(1,orbtype,iline{1});
      n_pG = cat(1,n_pG,str2num(iline{2}));
      tot_cG = tot_cG + 1;
    end
  end
  % Total number of contracted Gaussians w/out angular component
  basis.tot_cG = tot_cG;
  % Store angular component information
  basis.l = [];
  basis.m = [];
  basis.cG = [];
  for i = 1:tot_cG
    % Extract coefficients and exponents of primitive Gaussians for each contracted Gaussian
    varname = strcat('cGaussian',num2str(i));
    basis.(varname).alpha = [];
    basis.(varname).cp = [];
    for ip = 1:n_pG(i)
      iline = strsplit(str{header_line(i)+ip},' ');
      basis.(varname).alpha = cat(1,basis.(varname).alpha,str2double(iline{2}));
      basis.(varname).cp = cat(1,basis.(varname).cp,str2double(iline{3}));
    end
    basis.(varname).orb = orbtype(i);
    basis.(varname).n_pG = n_pG(i);
    % Construct basis ordering of l and m values for each atomic species
    % Also set which contracted Gaussian to read for each corresponding l value
    % m values for l=1 (p-orbital) ordered as (1,-1,0). If real-valued, as (x,y,z).
    % m values for l=2 (d-orbital) ordered as (0,1,-1,2,-2). If real-valued, as (d_z^2,d_xz,d_yz,d_x^2-y^2,d_xy).
    if orbtype(i) == 's'
      basis.l = cat(1,basis.l,0);
      basis.cG = cat(1,basis.cG,i);
      basis.m = cat(1,basis.m,0);
    elseif orbtype(i) == 'p'
      for im = 1:3
        basis.l = cat(1,basis.l,1);
        basis.cG = cat(1,basis.cG,i);
      end
      basis.m = cat(1,basis.m,transpose([1,-1,0]));
    elseif orbtype(i) == 'd'
      for im = 1:5
        basis.l = cat(1,basis.l,2);
        basis.cG = cat(1,basis.cG,i);
      end
      basis.m = cat(1,basis.m,transpose([0,1,-1,2,-2]));
    end
  end
end
