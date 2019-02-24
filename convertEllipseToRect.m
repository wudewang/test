img_dir = 'E:\originalPics\';
for i = 1:10
    fold_file = ['FDDB-folds/FDDB-fold-' sprintf('%02d',i) '-ellipseList.txt'];
    fid = fopen(fold_file,'r');
    if fid<0
        continue;
    end
    fold_file = ['FDDB-folds/FDDB-fold-' sprintf('%02d',i) '-rectList.txt'];
    save_file = fopen(fold_file','w');
     
    while ~feof(fid)
        img_str = fgetl(fid);
        img_file = [img_dir img_str '.jpg'];
        img = imread(img_file);
        w = size(img,2);
		h = size(img,1);
        face_num = fgetl(fid);
        face_num = str2double(face_num);
        for j = 1:face_num
            face_ellipse = fgetl(fid);
            face_ellipse = strsplit(face_ellipse);
            a = str2double(face_ellipse{1,1});
            b = str2double(face_ellipse{1,2});
            angle = str2double(face_ellipse{1,3});
            centre_x = str2double(face_ellipse{1,4});
            centre_y = str2double(face_ellipse{1,5});
            tan_t = -(b/a)*tan(angle);
            t = atan(tan_t);
            x1 = centre_x + (a*cos(t)*cos(angle) - b*sin(t)*sin(angle));
            x2 = centre_x + (a*cos(t+pi)*cos(angle) - b*sin(t+pi)*sin(angle));
            x_max = filterCoordinate(max(x1,x2),w);
            x_min = filterCoordinate(min(x1,x2),w);
            if tan(angle) ~= 0
                tan_t = (b/a)*(1/tan(angle));
            else
                tan_t = (b/a)*(1/(tan(angle)+0.0001));
            end
            t = atan(tan_t);
            y1 = centre_y + (b*sin(t)*cos(angle) + a*cos(t)*sin(angle));
            y2 = centre_y + (b*sin(t+pi)*cos(angle) + a*cos(t+pi)*sin(angle));
            y_max = filterCoordinate(max(y1,y2),h);
            y_min = filterCoordinate(min(y1,y2),h);
            text = [img_str  ' '  num2str(x_min) ' '  num2str(y_min)  ' '  num2str(x_max)  ' '  num2str(y_max)];
            fprintf(save_file,'%s\n',text);
        end
    end
    fclose(fid);
    fclose(save_file);
end


