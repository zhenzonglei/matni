function coords = map_make_volroi(centerCoords,boundary,radius)
% ccoords = map_makevolroi(centerCoords,boundary,radius)
%
% centerCoords: Nx3 coordinate defining the sphere center.
% boundary, 1x3 vector, the boundary for the image which roi locate
% radius: scalar defining the radius, in voxel units
%
% If centerCoord is a 1x2, then we do a 2d version.
%
% RETURNS:
%  coords: an Nx1 cell array of the coordinates that intersect the sphere.

if nargin < 3, radius = 3;end

if(size(centerCoords,2)==2)
    [X,Y] = meshgrid([-radius:+radius],...
        [-radius:+radius]);
    dSq = X.^2+Y.^2;
    keep = dSq(:) < radius.^2;
    
    for  c = 1:size(centerCoords)
        sphere_coords = [X(keep)+centerCoords(c,1), ...
            Y(keep)+centerCoords(c,2)];
        
        % remove bad coords that lie outside the boundaries of the volume
        bad = sphere_coords(:,1)<1 | ...
            sphere_coords(:,2)<1 | ...
            sphere_coords(:,1)>boundary(1) | ...
            sphere_coords(:,2)>boundary(2);
        sphere_coords(bad,:) = [];
        coords{c,1} = sphere_coords;
    end
else
    [X,Y,Z] = meshgrid([-radius:+radius],...
        [-radius:+radius],...
        [-radius:+radius]);
    dSq = X.^2+Y.^2+Z.^2;
    keep = dSq(:) < radius.^2;
    for  c = 1:size(centerCoords)
        sphere_coords = [X(keep)+centerCoords(c,1), ...
            Y(keep)+centerCoords(c,2),...
            Z(keep)+centerCoords(c,3)];
        % remove bad coords that lie outside the boundaries of the volume
        bad = sphere_coords(:,1)<1 | ...
            sphere_coords(:,2)<1 | ...
            sphere_coords(:,3)<1 | ...
            sphere_coords(:,1)>boundary(1) | ...
            sphere_coords(:,2)>boundary(2) | ...
            sphere_coords(:,3)>boundary(3);
        sphere_coords(bad,:) = [];
        coords{c,1} = sphere_coords;
    end
end
return;