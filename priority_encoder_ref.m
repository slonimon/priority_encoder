clc;
clear;

%% priority_encoder_model %%

% Input data
width        = 5;
NUM_OF_WORDS = 10;
data_val_i   = randi([0, 1], NUM_OF_WORDS, 1);
data_i       = randi([0, 1], NUM_OF_WORDS, width);

% algoritm ref_model
data_left_o  = zeros(NUM_OF_WORDS, width);
data_right_o = zeros(NUM_OF_WORDS, width);
data_val_o   = zeros(NUM_OF_WORDS, 1);

for w = 1 : 1 : NUM_OF_WORDS
    [data_right_o(w, :), data_left_o(w, :)] = priority_encoder(data_i(w, :), width);

    data_i(w, :) = fliplr(data_i(w, :));
    data_left_o(w, :) = (data_left_o(w, :));
    data_right_o(w, :) = (data_right_o(w, :));
end 

ref_test_data_i = num2str(data_i, '%d');
ref_test_data_val_i = num2str(data_val_i, '%d');
ref_test_data_left_o = num2str(data_left_o, '%d');
ref_test_data_right_o = num2str(data_right_o, '%d');

writematrix(ref_test_data_i, 'ref_test_data_i.txt');
writematrix(ref_test_data_val_i, 'ref_test_data_val_i.txt');
writematrix(ref_test_data_left_o, 'ref_test_data_left_o.txt');
writematrix(ref_test_data_right_o, 'ref_test_data_right_o.txt');

%% function for find max/min ones bit
function [data_right_o, data_left_o] = priority_encoder(data_i, width)
    %% common variables and functions
    quadratik = eye(width);
    one_vec   = quadratik(width, :);
    
    function [res] = substruction(a, b)
        if ~any(a)
            res = zeros(1, width);
        else
            el1 = bin2dec(num2str(a(1, :)));
            el2 = bin2dec(num2str(b));
            sub = dec2bin(el1 - el2);
            res = str2double(num2cell(sub));
        end
    end

    %% find data_left_o
    revers_data_i = fliplr(data_i);
    
    % substruction operations
    res_left_sub    = substruction(revers_data_i, one_vec);
    length_res_left = length(res_left_sub);
    zero_vec_left   = zeros(1, width - length_res_left);
    res_sub_left    = [zero_vec_left, res_left_sub];
    
    % revers_data - preoutput
    revers_data_o =  bitand(revers_data_i, ~(res_sub_left));
    
    % output data for data_left_o
    data_left_o = fliplr(revers_data_o);
    
    %% find data_right_o
    % substruction operations
    res_right_sub    = substruction(data_i, one_vec);
    length_res_right = length(res_right_sub);
    zero_vec_right   = zeros(1, width - length_res_right);
    res_sub_right    = [zero_vec_right, res_right_sub];
    
    % output data for data_right_o
    data_right_o =  bitand(data_i, ~(res_sub_right));
end
