classdef AI_m < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        GridLayout               matlab.ui.container.GridLayout
        LeftPanel                matlab.ui.container.Panel
        EmergancyFunctionsPanel  matlab.ui.container.Panel
        BatteryLevelGauge        matlab.ui.control.LinearGauge
        BatteryLevelGaugeLabel   matlab.ui.control.Label
        EmergencyLandButton      matlab.ui.control.Button
        ReturnHomeButton         matlab.ui.control.Button
        DroneRespondingPanel     matlab.ui.container.Panel
        CheckpointBLamp          matlab.ui.control.Lamp
        CheckpointBLampLabel     matlab.ui.control.Label
        CheckpointALamp          matlab.ui.control.Lamp
        CheckpointALampLabel     matlab.ui.control.Label
        MonitorAreaPanel         matlab.ui.container.Panel
        TimeDropDown             matlab.ui.control.DropDown
        TimeDropDownLabel        matlab.ui.control.Label
        CheckpointBButton        matlab.ui.control.Button
        CheckpointAButton        matlab.ui.control.Button
        RightPanel               matlab.ui.container.Panel
        AlertsEditField          matlab.ui.control.EditField
        AlertsEditFieldLabel     matlab.ui.control.Label
        LiveFeedLabel            matlab.ui.control.Label
        UIAxes                   matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)

        drone;
        cam;
        detector;
        response;
        t;

    end
    
    
    
    methods (Access = public)
        
        function alarm(app)
            
            %make "i" empty
            t = [];
            %defines serial port and baud rate
            s = serialport("COM3",115200);
            
            while (isempty(t))
                
                %red serial line
                t = readline(s);
            
            end

            if contains(t,"A")
                
                if app.response == 0
                    
                    %Prevent drone response to second location
                    app.response = 1;

                    %get battery level and display
                    app.BatteryLevelGauge.Value = app.drone.BatteryLevel;

                    %prevents operational input from user
                    app.CheckpointAButton.Enable = 'off';
                    app.CheckpointBButton.Enable = 'off';

                    %Change lamp to green
                    app.CheckpointALamp.Color = [0 1 0];

                    %Display in Alerts box
                    app.AlertsEditField.Value = 'Drone Responding To Alarm At Checkpoint A';
                    
                    %Call function to respond to alarm
                    app.AlertsEditField.Value = AI_respond_A(app.drone,app.cam,app.detector);
                    
                    if app.AlertsEditField.Value == "Drone Responded and Returned Home"
                        
                        %change indicator to red
                        app.CheckpointALamp.Color = [1 0 0];
                        %re-enable input from user and system
                        app.CheckpointAButton.Enable = 'on';
                        app.CheckpointBButton.Enable = 'on';
                        app.response = 0;
                        
                    end
                
                elseif app.response == 1
                   
                    %Pop-up
                    uialert(figurealert,"Alarm at Checkpoint A. No drones available","ALERT!","Modal",true);
                    
                end


            elseif contains(t,"B")
                
                if app.response == 0

                    %Prevent drone response to second location
                    app.response = 1;

                    %get battery level and display
                    app.BatteryLevelGauge.Value = app.drone.BatteryLevel;

                    %prevents operational input from user
                    app.CheckpointAButton.Enable = 'off';
                    app.CheckpointBButton.Enable = 'off';

                    %Change lamp to green
                    app.CheckpointBLamp.Color = [0 1 0];

                    %Display in Alerts box
                    app.AlertsEditField.Value = 'Drone Responding To Alarm At Checkpoint B';
                    
                    %Call function to respond to alarm
                    app.AlertsEditField.Value = AI_respond_B(app.drone,app.cam,app.detector);
                    
                    if app.AlertsEditField.Value == "Drone Responded and Returned Home"
                        
                        %change indicator to red
                        app.CheckpointBLamp.Color = [1 0 0];
                        %re-enable input from user and system
                        app.CheckpointAButton.Enable = 'on';
                        app.CheckpointBButton.Enable = 'on';
                        app.response = 0;
                        
                    end
                
                %create pop-up if drone is responding already
                elseif app.response == 1
                   
                    %Pop-up
                    uialert(figurealert,"Alarm at Checkpoint B. No drones available","ALERT!","Modal",true);
                    
                end
                
            else

                %Pop-up
                uialert(figurealert,"Alarm system ERROR!","ALERT!","Modal",false);

            end
              
              
        end
      
    end    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           
            %connect to drone and camera
            app.drone = ryze();
            app.cam = camera(app.drone);
            
            %set-up camera view frame
            frame = snapshot(app.cam);
            im = image(app.UIAxes, zeros(size(frame),'uint8'));
            axis(app.UIAxes,'tight');
            %display feed into above frame
            preview(app.cam,im);
            %release axes view to show feed
            app.UIAxes.Visible = 'on';
            %get initial battery level and display
            app.BatteryLevelGauge.Value = app.drone.BatteryLevel;
            %enable alarm response
            app.response = 0;
            
            %Load YOLO AI detector
            pretrained = load('tinyYOLOV2-coco.mat');
            app.detector = pretrained.yolov2Detector;

            %start periodic function timer
            app.t = timer;
            app.t.Period = 5;
            app.t.TasksToExecute = inf;
            app.t.ExecutionMode = 'fixedRate';
            app.t.TimerFcn = @(~,~)alarm(app);
            
            start(app.t);
            
        end

        % Button pushed function: CheckpointAButton
        function CheckpointAButtonPushed(app, event)

            %stop function timer
            stop(app.t);
            %Prevent drone response to second location
            app.response = 1;
            %prevents second operation input from user
            app.CheckpointAButton.Enable = 'off';
            app.CheckpointBButton.Enable = 'off';
                        
            %get battery level and display
            app.BatteryLevelGauge.Value = app.drone.BatteryLevel;
            
            %determine length of area monitoring
            if contains(app.TimeDropDown.Value,'5 Seconds')

                m = 5;

            elseif contains(app.TimeDropDown.Value,'10 Seconds')


                m = 10;

            end
            
            %Call function to respond to alarm
            app.AlertsEditField.Value = AI_monitor_A(app.drone,app.cam,m,app.detector);
            
            if app.AlertsEditField.Value == "Drone Responded and Returned Home"
                        
                        %re-enable input from user and system
                        app.CheckpointAButton.Enable = 'on';
                        app.CheckpointBButton.Enable = 'on';
                        app.response = 0;
                        %start function timer
                        start(app.t)
                        
            end

        end

        % Button pushed function: EmergencyLandButton
        function EmergencyLandButtonPushed(app, event)
            
            %Land drone
            land(app.drone);
            %display in alerts line
            app.AlertsEditField.Value = 'Emergency Land';
            %clear drone to prevent operation
            clear(app.drone);

        end

        % Button pushed function: CheckpointBButton
        function CheckpointBButtonPushed(app, event)
            
            %stop function timer
            stop(app.t)
            %Prevent drone response to second location
            app.response = 1;
                        
            %get battery level and display
            app.BatteryLevelGauge.Value = app.drone.BatteryLevel;

            %prevents second operation input from user
            app.CheckpointAButton.Enable = 'off';
            app.CheckpointBButton.Enable = 'off';

            %determine length of area monitoring
            if contains(app.TimeDropDown.Value,'5 Seconds')

                m = 5;

            elseif contains(app.TimeDropDown.Value,'10 Seconds')


                m = 10;

            end
            
            %Call function to respond to alarm
            app.AlertsEditField.Value = AI_monitor_B(app.drone,app.cam,m,app.detector);
            
            if app.AlertsEditField.Value == "Drone Responded and Returned Home"
                        
                        %re-enable input from user and system
                        app.CheckpointAButton.Enable = 'on';
                        app.CheckpointBButton.Enable = 'on';
                        app.response = 0;
                        %start function timer
                        start(app.t);
                        
            end

        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {509, 509};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 876 509];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create MonitorAreaPanel
            app.MonitorAreaPanel = uipanel(app.LeftPanel);
            app.MonitorAreaPanel.Title = 'Monitor Area';
            app.MonitorAreaPanel.Position = [10 311 200 165];

            % Create CheckpointAButton
            app.CheckpointAButton = uibutton(app.MonitorAreaPanel, 'push');
            app.CheckpointAButton.ButtonPushedFcn = createCallbackFcn(app, @CheckpointAButtonPushed, true);
            app.CheckpointAButton.BusyAction = 'cancel';
            app.CheckpointAButton.Position = [1 98 199 42];
            app.CheckpointAButton.Text = 'Checkpoint A';

            % Create CheckpointBButton
            app.CheckpointBButton = uibutton(app.MonitorAreaPanel, 'push');
            app.CheckpointBButton.ButtonPushedFcn = createCallbackFcn(app, @CheckpointBButtonPushed, true);
            app.CheckpointBButton.BusyAction = 'cancel';
            app.CheckpointBButton.Position = [1 53 199 42];
            app.CheckpointBButton.Text = 'Checkpoint B';

            % Create TimeDropDownLabel
            app.TimeDropDownLabel = uilabel(app.MonitorAreaPanel);
            app.TimeDropDownLabel.HorizontalAlignment = 'center';
            app.TimeDropDownLabel.Position = [0 14 65 22];
            app.TimeDropDownLabel.Text = 'Time';

            % Create TimeDropDown
            app.TimeDropDown = uidropdown(app.MonitorAreaPanel);
            app.TimeDropDown.Items = {'5 Seconds', '10 Seconds'};
            app.TimeDropDown.Position = [79 1 118 47];
            app.TimeDropDown.Value = '5 Seconds';

            % Create DroneRespondingPanel
            app.DroneRespondingPanel = uipanel(app.LeftPanel);
            app.DroneRespondingPanel.Tooltip = {'When green, drone is responding to corresponding alarm'};
            app.DroneRespondingPanel.Title = 'Drone Responding';
            app.DroneRespondingPanel.Position = [10 195 200 101];

            % Create CheckpointALampLabel
            app.CheckpointALampLabel = uilabel(app.DroneRespondingPanel);
            app.CheckpointALampLabel.HorizontalAlignment = 'right';
            app.CheckpointALampLabel.Position = [43 47 76 22];
            app.CheckpointALampLabel.Text = 'Checkpoint A';

            % Create CheckpointALamp
            app.CheckpointALamp = uilamp(app.DroneRespondingPanel);
            app.CheckpointALamp.Position = [134 48 20 20];
            app.CheckpointALamp.Color = [1 0 0];

            % Create CheckpointBLampLabel
            app.CheckpointBLampLabel = uilabel(app.DroneRespondingPanel);
            app.CheckpointBLampLabel.HorizontalAlignment = 'right';
            app.CheckpointBLampLabel.Position = [42 7 77 22];
            app.CheckpointBLampLabel.Text = 'Checkpoint B';

            % Create CheckpointBLamp
            app.CheckpointBLamp = uilamp(app.DroneRespondingPanel);
            app.CheckpointBLamp.Position = [134 7 20 20];
            app.CheckpointBLamp.Color = [1 0 0];

            % Create EmergancyFunctionsPanel
            app.EmergancyFunctionsPanel = uipanel(app.LeftPanel);
            app.EmergancyFunctionsPanel.Title = 'Emergancy Functions';
            app.EmergancyFunctionsPanel.Position = [10 12 200 165];

            % Create ReturnHomeButton
            app.ReturnHomeButton = uibutton(app.EmergancyFunctionsPanel, 'push');
            app.ReturnHomeButton.Position = [1 98 199 42];
            app.ReturnHomeButton.Text = 'Return Home';

            % Create EmergencyLandButton
            app.EmergencyLandButton = uibutton(app.EmergancyFunctionsPanel, 'push');
            app.EmergencyLandButton.ButtonPushedFcn = createCallbackFcn(app, @EmergencyLandButtonPushed, true);
            app.EmergencyLandButton.BusyAction = 'cancel';
            app.EmergencyLandButton.Interruptible = 'off';
            app.EmergencyLandButton.Position = [1 53 199 42];
            app.EmergencyLandButton.Text = 'Emergency Land';

            % Create BatteryLevelGaugeLabel
            app.BatteryLevelGaugeLabel = uilabel(app.EmergancyFunctionsPanel);
            app.BatteryLevelGaugeLabel.HorizontalAlignment = 'center';
            app.BatteryLevelGaugeLabel.Position = [63 -3 76 22];
            app.BatteryLevelGaugeLabel.Text = 'Battery Level';

            % Create BatteryLevelGauge
            app.BatteryLevelGauge = uigauge(app.EmergancyFunctionsPanel, 'linear');
            app.BatteryLevelGauge.MajorTicks = [0 20 40 60 80 100];
            app.BatteryLevelGauge.Position = [5 18 192 31];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.Visible = 'off';
            app.UIAxes.Position = [8 74 640 359];

            % Create LiveFeedLabel
            app.LiveFeedLabel = uilabel(app.RightPanel);
            app.LiveFeedLabel.Position = [8 432 173 22];
            app.LiveFeedLabel.Text = 'Live Feed';

            % Create AlertsEditFieldLabel
            app.AlertsEditFieldLabel = uilabel(app.RightPanel);
            app.AlertsEditFieldLabel.HorizontalAlignment = 'right';
            app.AlertsEditFieldLabel.Position = [8 28 55 22];
            app.AlertsEditFieldLabel.Text = 'Alerts';

            % Create AlertsEditField
            app.AlertsEditField = uieditfield(app.RightPanel, 'text');
            app.AlertsEditField.Editable = 'off';
            app.AlertsEditField.Position = [78 12 559 54];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AI_m

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end