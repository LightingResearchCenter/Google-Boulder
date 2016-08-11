function obj = crop(obj)
%CROP Summary of this function goes here
%   Detailed explanation goes here

f = figure;
f.Units = 'normalized';
f.Position = [0,0,1,1];
ax = axes(f);

%% Observation cropping
loop1 = true;
while loop1
    plot(ax,obj.Time,[obj.ActivityIndex,obj.CircadianStimulus])
    
    uiwait(msgbox('Select start of observation.','','modal'));
    [x1,~] = zoompick(ax);
    
    uiwait(msgbox('Select end of observation.','','modal'));
    [x2,~] = zoompick(ax);
    
    idx = datenum(obj.Time) >= x1 & datenum(obj.Time) < x2;
    plot(ax,obj.Time(idx),[obj.ActivityIndex(idx),obj.CircadianStimulus(idx)])
    
    button = questdlg('Is this selection correct?',...
        'Confirm','Yes','No','Yes');
    if strcmpi(button,'Yes')
        obj.Observation = idx;
        loop1 = false;
    end
end

%% Bed cropping
button = questdlg('Would you like to select bed times?','','Yes','No','Yes');
if strcmpi(button,'Yes')
    loop1 = true;
    while loop1
        
        loop2 = true;
        while loop2
            
            uiwait(msgbox('Select bed time.','','modal'));
            [x1,~] = zoompick(ax);
            
            uiwait(msgbox('Select rise time.','','modal'));
            [x2,~] = zoompick(ax);
            
            hold(ax,'on');
            y1 = ax.YLim(1);
            y2 = ax.YLim(2);
            h = area([x1,x1,x2,x2],[y1,y2,y2,y1]);
            uistack(h,'bottom');
            hold(ax,'off')
            
            button = questdlg('Is this selection correct?','','Yes','No','Yes');
            if strcmpi(button,'Yes')
                t1 = datetime(x1,'ConvertFrom','datenum','TimeZone',obj.Time(1).TimeZone);
                t2 = datetime(x2,'ConvertFrom','datenum','TimeZone',obj.Time(1).TimeZone);
                if isempty(obj.BedLog)
                    obj.BedLog = d12pack.BedLogData(t1,t2);
                else
                    obj.BedLog = [obj.BedLog; d12pack.BedLogData(t1,t2)];
                end
                loop2 = false;
            else
                delete(h);
            end
        end
        
        button = questdlg('Would you like to select more bed times?','','Yes','No','Yes');
        if strcmpi(button,'No')
            loop1 = false;
        end
        
    end
end

%% Error cropping
button = questdlg('Would you like to select device errors?','','Yes','No','Yes');
if strcmpi(button,'Yes')
    loop1 = true;
    while loop1
        
        loop2 = true;
        while loop2
            
            uiwait(msgbox('Select start of error.','','modal'));
            [x1,~] = zoompick(ax);
            
            uiwait(msgbox('Select end of error.','','modal'));
            [x2,~] = zoompick(ax);
            
            hold(ax,'on');
            y1 = ax.YLim(1);
            y2 = ax.YLim(2);
            h = area([x1,x1,x2,x2],[y1,y2,y2,y1]);
            h.FaceColor = 'red';
            uistack(h,'bottom');
            hold(ax,'off')
            
            button = questdlg('Is this selection correct?','','Yes','No','Yes');
            if strcmpi(button,'Yes')
                idx = datenum(obj.Time) >= x1 & datenum(obj.Time) < x2;
                obj.Error = obj.Error | idx;
                loop2 = false;
            else
                delete(h);
            end
        end
        
        button = questdlg('Would you like to select more device errors?','','Yes','No','Yes');
        if strcmpi(button,'No')
            loop1 = false;
        end
        
    end
end

%% Non-compliance cropping
button = questdlg('Would you like to select subject non-compliance?','','Yes','No','Yes');
if strcmpi(button,'Yes')
    loop1 = true;
    while loop1
        
        loop2 = true;
        while loop2
            
            uiwait(msgbox('Select start of non-compliance.','','modal'));
            [x1,~] = zoompick(ax);
            
            uiwait(msgbox('Select end of non-copmliance.','','modal'));
            [x2,~] = zoompick(ax);
            
            hold(ax,'on');
            y1 = ax.YLim(1);
            y2 = ax.YLim(2);
            h = area([x1,x1,x2,x2],[y1,y2,y2,y1]);
            h.FaceColor = [0.5 0.5 0.5];
            uistack(h,'bottom');
            hold(ax,'off')
            
            button = questdlg('Is this selection correct?','','Yes','No','Yes');
            if strcmpi(button,'Yes')
                idx = datenum(obj.Time) >= x1 & datenum(obj.Time) < x2;
                obj.Error = obj.Error | idx;
                loop2 = false;
            else
                delete(h);
            end
        end
        
        button = questdlg('Would you like to select more non-compliance?','','Yes','No','Yes');
        if strcmpi(button,'No')
            loop1 = false;
        end
        
    end
end


close(f)
end


%%
function [x,y] = zoompick(ax)
clc
zoom(ax,'on')
display('Press SPACE BAR to continue');
ax.Parent.CurrentCharacter = 'z';
waitfor(ax.Parent,'CurrentCharacter',char(32));
zoom(ax,'off')
[x,y] = ginput(1);
zoom(ax,'out')
clc
end
