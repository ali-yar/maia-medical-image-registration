function M = transformation_matrix(type, x)
% Make the affine transformation matrix

switch type
	case 'r'
        M = [ cos(x(3)) sin(x(3)) x(1);
             -sin(x(3)) cos(x(3)) x(2);
               0           0      1 ];
	case 'a1'
        M = [ x(3)  x(4)    x(1);
              x(5)  x(6)	x(2);
              0       0 	1  ];
    case 'a2'
        Rot = [ cos(x(3)) sin(x(3)) 0;
               -sin(x(3)) cos(x(3)) 0;
                 0           0      1 ];
        Transl = [ 1    0   x(1);
                  0    1   x(2);
                  0    0    1 ];
        Scale = [  x(4)  0    0;
                   0     x(5)  0;
                   0     0     1 ];
        ShearX = [ 1    x(6)   0;
                   0     1     0;
                   0     0     1 ];
        ShearY = [ 1     0     0;
                   x(7)  1     0;
                   0     0     1 ];
        M = Rot * Transl * Scale * ShearX * ShearY;
end
     
end

