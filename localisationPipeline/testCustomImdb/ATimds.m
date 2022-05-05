classdef ATimds < imageDatastore
    properties
        BF (1,1) {mustBeNumeric}
    end
    methods
        function obj = ATimds(path, BF)
            obj@imageDatastore(path);
        end
    end


end


