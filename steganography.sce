clc
clear
close(winsid());

function hide(input_file_name,secret_message,output_file_name) 
    end_point = "*!MKZ!*"
    secret_message = secret_message + end_point;
    secret_message_ascii = ascii(secret_message);
    secret_message_ascii_length = size(secret_message_ascii)(2);

    img = imread(input_file_name);
    img = double(img);
    [row,col,deep] = size(img);
    org_img = img

    pixel_counter = 0;
    message_iterator = 1;
    current_letter = secret_message_ascii(message_iterator);
    current_letter_binary = strrev(dec2bin(current_letter));
    current_letter_binary_index = 1;

    for i=1:row
        if message_iterator == secret_message_ascii_length then 
            break;
        end;
        for j=1:col
            pixel_counter = pixel_counter + 1;  
            for k=1:deep
                if current_letter_binary_index <= 8 then
                    temp = part(current_letter_binary,8 - current_letter_binary_index + 1);
                    if temp == " " then 
                        temp = 0;
                    else
                        temp = strtod(temp)
                    end;

                    img(i,j,k) = bitset(img(i,j,k),1,temp);
                    current_letter_binary_index = current_letter_binary_index + 1
                end;
            end;
            if pixel_counter == 3 then
                if message_iterator < secret_message_ascii_length then
                    message_iterator = message_iterator + 1;
                    current_letter = secret_message_ascii(message_iterator);
                    current_letter_binary = strrev(dec2bin(current_letter));
                else
                    break;
                end;
                current_letter_binary_index = 1;
                pixel_counter = 0; 
            end;
        end;
    end;

    imwrite(uint8(img),output_file_name)
    disp("Message is hided succesfully!")

    figure(1);
    title("Original");
    imshow(uint8(org_img));

    figure(2);
    title("Message Hided");
    imshow(uint8(img));
endfunction;

function unhide(input_file_name) 
    end_point = "*!MKZ!*"
    img = imread(input_file_name);
    img = double(img);
    [row,col,deep] = size(img);

    pixel_counter = 0;
    current_letter_binary_index = 1;
    current_binary_number = "";
    result_text = "";
    end_point_result = [];

    for i=1:row
        if end_point_result <> [] then 
            break;
        end;
        for j=1:col
            pixel_counter = pixel_counter + 1;
            for k=1:deep
                if current_letter_binary_index <= 8 then
                    temp = dec2bin(img(i,j,k))
                    temp = part(temp,length(temp))
                    current_binary_number = current_binary_number +  temp;

                    current_letter_binary_index = current_letter_binary_index + 1
                end;
            end;
            if pixel_counter == 3 then
                current_letter_binary_index = 1;
                pixel_counter = 0; 
                current_decimal_number = bin2dec(current_binary_number);
                current_letter = ascii(current_decimal_number);
                result_text = result_text + current_letter;
                current_binary_number = "";

                end_point_result = strindex(result_text,end_point);
                if end_point_result <> [] then
                    result_text = part(result_text,1:length(result_text)-length(end_point))
                    break;
                end; 
            end;
        end;
    end;

    figure(0);
    if end_point_result <> [] then 
        disp("Secret Message Found!")
        disp(result_text);
        title(result_text);
    else 
        error_message = "Secret Message NOT Found!"
        disp(error_message);
        title(error_message);
    end;
    imshow(uint8(img));
endfunction;


/* HIDE */
hide_input_file_name = "lena.bmp";
secret_message = "Work until you no longer have to introduce yourself!";
output_file_name = "lenaTEXT.bmp";

hide(hide_input_file_name,secret_message,output_file_name);

/* UNHIDE */
unhide_input_file_name = "lenaTEXT.bmp";

unhide(unhide_input_file_name);



