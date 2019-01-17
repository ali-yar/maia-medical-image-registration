function s = minPtsToFitModel(model)

switch model
    case {'euclidean','similarity'}
        s = 2;
    case 'affine'
        s = 3;
    case 'projective'
        s = 4;
    otherwise
        s = 4;
end

end

