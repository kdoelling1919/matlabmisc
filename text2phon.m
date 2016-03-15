function [ phones ] = text2phon(words,dictfile)
% text2phon reads in words and spits out phoneme transcription based on CMU dictionary
%   INPUTS
%   words = String of words separated by spaces or cell array of strings
%   dictfile = location of dictionary textfile
%
%   OUTPUT
%   phones = cell array of strings with the phonemes given based on CMU.
%           Each cell will contain a cell array of size depending on number
%           of potential pronunciations or an empty cell array if the word
%           was not found.
%
%   Created by Keith Doelling, March 15, 2016


% separate string into char
if ischar(words)
    words = regexp(words,' ','split');
elseif iscell(words)
    checkwords = cellfun(@ischar,words);
    if ~all(checkwords)
        error('First input must be a char array or cell array of strings'); 
    end
else
    error('First input must be a char array or cell array of strings');
end

% Check dictionary
if ischar(dictfile)
    if ~exist(dictfile,'file')
        error('No such dictionary file in existence')
    end
else
    error('Second input must be a string: filepath to the dictionary file');
end

% read in dictionary file
fid = fopen(dictfile,'r');
dict = textscan(fid,'%s','CommentStyle',';;;','Delimiter','\n');
fclose(fid);
dict = dict{1};
phones = cell(size(words));
% search for entries and output cell array of phonemes matching search
for ind = 1:length(words)
    word = words{ind};
    len = length(word);
    %search dictionary
    matches = strncmpi(word,dict,len);
    
    % hold lines that match
    lines = dict(matches);
    if isempty(lines)
        phones{ind} = cell([0 1]);
        continue
    end
    
    % split off the word and leave the phonemes
    linesplit = regexp(lines,'  ','split');
    linecheck = [linesplit{:}];
    linecheck = char(linecheck(1:2:end));
    test = linecheck(:,len+1)==' ' | linecheck(:,len+1)=='(';
    phones{ind} = cellfun(@(x) x{2},linesplit(test),'UniformOutput',false);
end
end

