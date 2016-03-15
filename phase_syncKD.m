function [ sync ] = phase_syncKD( a,b )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sync = circ_dist(angle(hilbert(b)),angle(hilbert(a)));
end

