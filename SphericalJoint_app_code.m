classdef SphericalJoint_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        Link3EditField             matlab.ui.control.NumericEditField
        Link3EditFieldLabel        matlab.ui.control.Label
        LinkLengthdefaultis1Label  matlab.ui.control.Label
        Link2EditField             matlab.ui.control.NumericEditField
        Link2EditFieldLabel        matlab.ui.control.Label
        Link1EditField             matlab.ui.control.NumericEditField
        Link1EditFieldLabel        matlab.ui.control.Label
        EditField_4                matlab.ui.control.EditField
        Joint4Label                matlab.ui.control.Label
        Joint3Label_2              matlab.ui.control.Label
        Joint2Label_2              matlab.ui.control.Label
        Joint1Label_2              matlab.ui.control.Label
        JointInputsindegreesdefaultis0Label  matlab.ui.control.Label
        JointCoordinatesXYZLabel   matlab.ui.control.Label
        EditField_3                matlab.ui.control.EditField
        EditField_2                matlab.ui.control.EditField
        EditField                  matlab.ui.control.EditField
        delta2L2L3EditField        matlab.ui.control.EditField
        delta2L2L3EditFieldLabel   matlab.ui.control.Label
        delta1L1L2EditField        matlab.ui.control.EditField
        delta1L1L2EditFieldLabel   matlab.ui.control.Label
        LinkAngleindegreesLabel    matlab.ui.control.Label
        RollLabel                  matlab.ui.control.Label
        PitchLabel                 matlab.ui.control.Label
        YawLabel                   matlab.ui.control.Label
        YEditField_3               matlab.ui.control.NumericEditField
        YEditField_3Label          matlab.ui.control.Label
        XEditField_3               matlab.ui.control.NumericEditField
        XEditField_3Label          matlab.ui.control.Label
        ZEditField_3               matlab.ui.control.NumericEditField
        ZEditField_3Label          matlab.ui.control.Label
        Joint3Label                matlab.ui.control.Label
        YEditField_2               matlab.ui.control.NumericEditField
        YEditField_2Label          matlab.ui.control.Label
        XEditField_2               matlab.ui.control.NumericEditField
        XEditField_2Label          matlab.ui.control.Label
        ZEditField_2               matlab.ui.control.NumericEditField
        ZEditField_2Label          matlab.ui.control.Label
        Joint2Label                matlab.ui.control.Label
        Joint1Label                matlab.ui.control.Label
        YEditField                 matlab.ui.control.NumericEditField
        YEditFieldLabel            matlab.ui.control.Label
        XEditField                 matlab.ui.control.NumericEditField
        XEditFieldLabel            matlab.ui.control.Label
        ZEditField                 matlab.ui.control.NumericEditField
        ZEditFieldLabel            matlab.ui.control.Label
        StopButton                 matlab.ui.control.Button
        StartButton                matlab.ui.control.Button
        UIAxes                     matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        alpha1 = 0; beta1 = 0; gamma1 = 0;
        alpha2 = 0; beta2 = 0; gamma2 = 0;
        alpha3 = 0; beta3 = 0; gamma3 = 0;
        rel_pos = [0 0 0 1]';
        delta1 = 0; delta2 = 0;
        l1 = 1 ; l2 = 1; l3 = 1;
        Sim = true;
        p = 0;
        
    end
    
    methods (Access = public)
        
        function R = rot(app,theta, axis_name)
             if axis_name == 'x'
                R = [1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1];
            elseif axis_name == 'y'
                R = [cos(theta) 0 sin(theta) 0; 0 1 0 0; -sin(theta) 0 cos(theta) 0; 0 0 0 1];
            elseif axis_name == 'z'
                R = [cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0;0 0 1 0; 0 0 0 1];
            end
        end
        
        function T = trans(app, d, axis_name)
            if axis_name == 'x'
                T = [1 0 0 d;0 1 0 0;0 0 1 0;0 0 0 1];
            elseif axis_name == 'y'
                T = [1 0 0 0;0 1 0 d;0 0 1 0;0 0 0 1];
            elseif axis_name == 'z'
                T = [1 0 0 0;0 1 0 l0;0 0 1 d;0 0 0 1];
            end
        end
        
        function delta = LinkAngleCalc(app, vec1,vec2)
            delta = rad2deg(acos(dot(vec2,vec1)/(norm(vec1)*norm(vec2))));
        end
        
        function simulator(app)
            
                T1 = trans(app,app.l1,'y');
                T2 = trans(app,app.l2,'y');
                T3 = trans(app,app.l3,'y');
                
                RX1 = rot(app,app.alpha1, 'x');
                RY1 = rot(app,app.beta1, 'y');
                RZ1 = rot(app,app.gamma1, 'z');
                
                RX2 = rot(app,app.alpha2, 'x');
                RY2 = rot(app,app.beta2, 'y');
                RZ2 = rot(app,app.gamma2, 'z');
                
                RX3 = rot(app,app.alpha3, 'x');
                RY3 = rot(app,app.beta3, 'y');
                RZ3 = rot(app,app.gamma3, 'z');
                
                J4 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*RZ3*RX3*RY3*T3*app.rel_pos;
                J3 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*app.rel_pos;
                J2 = RZ1*RX1*RY1*T1*app.rel_pos;
                J1 = app.rel_pos;
                
                act_pos = [J1 J2 J3 J4];
                act_pos = act_pos(1:3,:);
                
                app.EditField.Value = num2str(round(act_pos(:,1)',2));
                app.EditField_2.Value = num2str(round(act_pos(:,2)',2));
                app.EditField_3.Value = num2str(round(act_pos(:,3)',2));
                app.EditField_4.Value = num2str(round(act_pos(:,4)',2));
                
                app.delta1 = LinkAngleCalc(app,act_pos(:,2)-act_pos(:,1), act_pos(:,3)-act_pos(:,2));
                app.delta2 = LinkAngleCalc(app,act_pos(:,3)-act_pos(:,2), act_pos(:,4)-act_pos(:,3));
                app.delta1L1L2EditField.Value = num2str(round(app.delta1,2));
                app.delta2L2L3EditField.Value = num2str(round(app.delta2,2));
                
                set(app.p,'XData', act_pos(1,:),'YData', act_pos(2,:),'ZData', act_pos(3,:));
                drawnow;             
                            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
                T1 = trans(app,app.l1,'y');
                T2 = trans(app,app.l2,'y');
                T3 = trans(app,app.l3,'y');
                
                RX1 = rot(app,app.alpha1, 'x');
                RY1 = rot(app,app.beta1, 'y');
                RZ1 = rot(app,app.gamma1, 'z');
                
                RX2 = rot(app,app.alpha2, 'x');
                RY2 = rot(app,app.beta2, 'y');
                RZ2 = rot(app,app.gamma2, 'z');
                
                RX3 = rot(app,app.alpha3, 'x');
                RY3 = rot(app,app.beta3, 'y');
                RZ3 = rot(app,app.gamma3, 'z');
                
                J4 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*RZ3*RX3*RY3*T3*app.rel_pos;
                J3 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*app.rel_pos;
                J2 = RZ1*RX1*RY1*T1*app.rel_pos;
                J1 = app.rel_pos;
                
                act_pos = [J1 J2 J3 J4];
                act_pos = act_pos(1:3,:);
                
                app.delta1 = LinkAngleCalc(app,act_pos(:,2)-act_pos(:,1), act_pos(:,3)-act_pos(:,2));
                app.delta2 = LinkAngleCalc(app,act_pos(:,3)-act_pos(:,2), act_pos(:,4)-act_pos(:,3));
                
                app.p = plot3(app.UIAxes,act_pos(1,:),act_pos(2,:),act_pos(3,:),'o','LineStyle','-','LineWidth',2,'Color','k','MarkerFaceColor','b','MarkerEdgeColor','b');

                while app.Sim
                    simulator(app);
                end
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            app.Sim = false;
        end

        % Value changed function: ZEditField
        function ZEditFieldValueChanged(app, event)
            app.gamma1 = deg2rad(app.ZEditField.Value);
            
        end

        % Value changed function: XEditField
        function XEditFieldValueChanged(app, event)
            app.alpha1 = deg2rad(app.XEditField.Value);
            
        end

        % Value changed function: YEditField
        function YEditFieldValueChanged(app, event)
            app.beta1 = deg2rad(app.YEditField.Value);
            
        end

        % Value changed function: ZEditField_2
        function ZEditField_2ValueChanged(app, event)
            app.gamma2 = deg2rad(app.ZEditField_2.Value);
            
        end

        % Value changed function: XEditField_2
        function XEditField_2ValueChanged(app, event)
            app.alpha2 = deg2rad(app.XEditField_2.Value);
            
        end

        % Value changed function: YEditField_2
        function YEditField_2ValueChanged(app, event)
            app.beta2 = deg2rad(app.YEditField_2.Value);
            
        end

        % Value changed function: ZEditField_3
        function ZEditField_3ValueChanged(app, event)
            app.gamma3 = deg2rad(app.ZEditField_3.Value);
            
        end

        % Value changed function: XEditField_3
        function XEditField_3ValueChanged(app, event)
            app.alpha3 = deg2rad(app.XEditField_3.Value);
            
        end

        % Value changed function: YEditField_3
        function YEditField_3ValueChanged(app, event)
            app.beta3 = deg2rad(app.YEditField_3.Value);
       
        end

        % Value changed function: Link1EditField
        function Link1EditFieldValueChanged(app, event)
            app.l1 = app.Link1EditField.Value;
            
        end

        % Value changed function: Link2EditField
        function Link2EditFieldValueChanged(app, event)
            app.l2 = app.Link2EditField.Value;
            
        end

        % Value changed function: Link3EditField
        function Link3EditFieldValueChanged(app, event)
            app.l3 = app.Link3EditField.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 919 671];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '9 DOF Manipulator')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.ZGrid = 'on';
            app.UIAxes.ZMinorGrid = 'on';
            app.UIAxes.Position = [29 209 664 442];

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Position = [756 608 40 22];
            app.StartButton.Text = 'Start';

            % Create StopButton
            app.StopButton = uibutton(app.UIFigure, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Position = [821 608 40 22];
            app.StopButton.Text = 'Stop';

            % Create ZEditFieldLabel
            app.ZEditFieldLabel = uilabel(app.UIFigure);
            app.ZEditFieldLabel.HorizontalAlignment = 'center';
            app.ZEditFieldLabel.Position = [320 115 25 22];
            app.ZEditFieldLabel.Text = 'Z';

            % Create ZEditField
            app.ZEditField = uieditfield(app.UIFigure, 'numeric');
            app.ZEditField.ValueChangedFcn = createCallbackFcn(app, @ZEditFieldValueChanged, true);
            app.ZEditField.HorizontalAlignment = 'center';
            app.ZEditField.Position = [360 115 37 22];

            % Create XEditFieldLabel
            app.XEditFieldLabel = uilabel(app.UIFigure);
            app.XEditFieldLabel.HorizontalAlignment = 'center';
            app.XEditFieldLabel.Position = [321 64 25 22];
            app.XEditFieldLabel.Text = 'X';

            % Create XEditField
            app.XEditField = uieditfield(app.UIFigure, 'numeric');
            app.XEditField.ValueChangedFcn = createCallbackFcn(app, @XEditFieldValueChanged, true);
            app.XEditField.HorizontalAlignment = 'center';
            app.XEditField.Position = [361 64 37 22];

            % Create YEditFieldLabel
            app.YEditFieldLabel = uilabel(app.UIFigure);
            app.YEditFieldLabel.HorizontalAlignment = 'center';
            app.YEditFieldLabel.Position = [322 17 25 22];
            app.YEditFieldLabel.Text = 'Y';

            % Create YEditField
            app.YEditField = uieditfield(app.UIFigure, 'numeric');
            app.YEditField.ValueChangedFcn = createCallbackFcn(app, @YEditFieldValueChanged, true);
            app.YEditField.HorizontalAlignment = 'center';
            app.YEditField.Position = [362 17 37 22];

            % Create Joint1Label
            app.Joint1Label = uilabel(app.UIFigure);
            app.Joint1Label.HorizontalAlignment = 'center';
            app.Joint1Label.Position = [362 153 41 22];
            app.Joint1Label.Text = 'Joint 1';

            % Create Joint2Label
            app.Joint2Label = uilabel(app.UIFigure);
            app.Joint2Label.HorizontalAlignment = 'center';
            app.Joint2Label.Position = [453 153 41 22];
            app.Joint2Label.Text = 'Joint 2';

            % Create ZEditField_2Label
            app.ZEditField_2Label = uilabel(app.UIFigure);
            app.ZEditField_2Label.HorizontalAlignment = 'center';
            app.ZEditField_2Label.Position = [413 115 25 22];
            app.ZEditField_2Label.Text = 'Z';

            % Create ZEditField_2
            app.ZEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.ZEditField_2.ValueChangedFcn = createCallbackFcn(app, @ZEditField_2ValueChanged, true);
            app.ZEditField_2.HorizontalAlignment = 'center';
            app.ZEditField_2.Position = [453 115 37 22];

            % Create XEditField_2Label
            app.XEditField_2Label = uilabel(app.UIFigure);
            app.XEditField_2Label.HorizontalAlignment = 'center';
            app.XEditField_2Label.Position = [413 64 25 22];
            app.XEditField_2Label.Text = 'X';

            % Create XEditField_2
            app.XEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.XEditField_2.ValueChangedFcn = createCallbackFcn(app, @XEditField_2ValueChanged, true);
            app.XEditField_2.HorizontalAlignment = 'center';
            app.XEditField_2.Position = [453 64 37 22];

            % Create YEditField_2Label
            app.YEditField_2Label = uilabel(app.UIFigure);
            app.YEditField_2Label.HorizontalAlignment = 'center';
            app.YEditField_2Label.Position = [413 17 25 22];
            app.YEditField_2Label.Text = 'Y';

            % Create YEditField_2
            app.YEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.YEditField_2.ValueChangedFcn = createCallbackFcn(app, @YEditField_2ValueChanged, true);
            app.YEditField_2.HorizontalAlignment = 'center';
            app.YEditField_2.Position = [453 17 37 22];

            % Create Joint3Label
            app.Joint3Label = uilabel(app.UIFigure);
            app.Joint3Label.HorizontalAlignment = 'center';
            app.Joint3Label.Position = [548 153 41 22];
            app.Joint3Label.Text = 'Joint 3';

            % Create ZEditField_3Label
            app.ZEditField_3Label = uilabel(app.UIFigure);
            app.ZEditField_3Label.HorizontalAlignment = 'center';
            app.ZEditField_3Label.Position = [513 115 25 22];
            app.ZEditField_3Label.Text = 'Z';

            % Create ZEditField_3
            app.ZEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.ZEditField_3.ValueChangedFcn = createCallbackFcn(app, @ZEditField_3ValueChanged, true);
            app.ZEditField_3.HorizontalAlignment = 'center';
            app.ZEditField_3.Position = [553 115 37 22];

            % Create XEditField_3Label
            app.XEditField_3Label = uilabel(app.UIFigure);
            app.XEditField_3Label.HorizontalAlignment = 'center';
            app.XEditField_3Label.Position = [513 64 25 22];
            app.XEditField_3Label.Text = 'X';

            % Create XEditField_3
            app.XEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.XEditField_3.ValueChangedFcn = createCallbackFcn(app, @XEditField_3ValueChanged, true);
            app.XEditField_3.HorizontalAlignment = 'center';
            app.XEditField_3.Position = [553 64 37 22];

            % Create YEditField_3Label
            app.YEditField_3Label = uilabel(app.UIFigure);
            app.YEditField_3Label.HorizontalAlignment = 'center';
            app.YEditField_3Label.Position = [513 17 25 22];
            app.YEditField_3Label.Text = 'Y';

            % Create YEditField_3
            app.YEditField_3 = uieditfield(app.UIFigure, 'numeric');
            app.YEditField_3.ValueChangedFcn = createCallbackFcn(app, @YEditField_3ValueChanged, true);
            app.YEditField_3.HorizontalAlignment = 'center';
            app.YEditField_3.Position = [553 17 37 22];

            % Create YawLabel
            app.YawLabel = uilabel(app.UIFigure);
            app.YawLabel.HorizontalAlignment = 'center';
            app.YawLabel.Position = [281 115 28 22];
            app.YawLabel.Text = 'Yaw';

            % Create PitchLabel
            app.PitchLabel = uilabel(app.UIFigure);
            app.PitchLabel.HorizontalAlignment = 'center';
            app.PitchLabel.Position = [281 64 32 22];
            app.PitchLabel.Text = 'Pitch';

            % Create RollLabel
            app.RollLabel = uilabel(app.UIFigure);
            app.RollLabel.HorizontalAlignment = 'center';
            app.RollLabel.Position = [281 17 26 22];
            app.RollLabel.Text = 'Roll';

            % Create LinkAngleindegreesLabel
            app.LinkAngleindegreesLabel = uilabel(app.UIFigure);
            app.LinkAngleindegreesLabel.Position = [759 387 120 22];
            app.LinkAngleindegreesLabel.Text = 'Link Angle in degrees';

            % Create delta1L1L2EditFieldLabel
            app.delta1L1L2EditFieldLabel = uilabel(app.UIFigure);
            app.delta1L1L2EditFieldLabel.HorizontalAlignment = 'right';
            app.delta1L1L2EditFieldLabel.Position = [732 353 82 22];
            app.delta1L1L2EditFieldLabel.Text = 'delta1(L1&L2)';

            % Create delta1L1L2EditField
            app.delta1L1L2EditField = uieditfield(app.UIFigure, 'text');
            app.delta1L1L2EditField.Position = [821 353 72 22];

            % Create delta2L2L3EditFieldLabel
            app.delta2L2L3EditFieldLabel = uilabel(app.UIFigure);
            app.delta2L2L3EditFieldLabel.HorizontalAlignment = 'right';
            app.delta2L2L3EditFieldLabel.Position = [732 305 82 22];
            app.delta2L2L3EditFieldLabel.Text = 'delta2(L2&L3)';

            % Create delta2L2L3EditField
            app.delta2L2L3EditField = uieditfield(app.UIFigure, 'text');
            app.delta2L2L3EditField.Position = [822 305 71 22];

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.Position = [723 159 170 22];

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.Position = [723 108 170 22];

            % Create EditField_3
            app.EditField_3 = uieditfield(app.UIFigure, 'text');
            app.EditField_3.Position = [723 61 170 22];

            % Create JointCoordinatesXYZLabel
            app.JointCoordinatesXYZLabel = uilabel(app.UIFigure);
            app.JointCoordinatesXYZLabel.Position = [739 187 140 22];
            app.JointCoordinatesXYZLabel.Text = 'Joint Coordinates (X Y Z)';

            % Create JointInputsindegreesdefaultis0Label
            app.JointInputsindegreesdefaultis0Label = uilabel(app.UIFigure);
            app.JointInputsindegreesdefaultis0Label.HorizontalAlignment = 'center';
            app.JointInputsindegreesdefaultis0Label.Position = [362 187 197 22];
            app.JointInputsindegreesdefaultis0Label.Text = 'Joint Inputs in degrees (default is 0)';

            % Create Joint1Label_2
            app.Joint1Label_2 = uilabel(app.UIFigure);
            app.Joint1Label_2.Position = [656 159 38 22];
            app.Joint1Label_2.Text = 'Joint1';

            % Create Joint2Label_2
            app.Joint2Label_2 = uilabel(app.UIFigure);
            app.Joint2Label_2.Position = [656 108 38 22];
            app.Joint2Label_2.Text = 'Joint2';

            % Create Joint3Label_2
            app.Joint3Label_2 = uilabel(app.UIFigure);
            app.Joint3Label_2.Position = [656 61 38 22];
            app.Joint3Label_2.Text = 'Joint3';

            % Create Joint4Label
            app.Joint4Label = uilabel(app.UIFigure);
            app.Joint4Label.Position = [656 18 38 22];
            app.Joint4Label.Text = 'Joint4';

            % Create EditField_4
            app.EditField_4 = uieditfield(app.UIFigure, 'text');
            app.EditField_4.Position = [723 18 170 22];

            % Create Link1EditFieldLabel
            app.Link1EditFieldLabel = uilabel(app.UIFigure);
            app.Link1EditFieldLabel.HorizontalAlignment = 'right';
            app.Link1EditFieldLabel.Position = [71 115 34 22];
            app.Link1EditFieldLabel.Text = 'Link1';

            % Create Link1EditField
            app.Link1EditField = uieditfield(app.UIFigure, 'numeric');
            app.Link1EditField.ValueChangedFcn = createCallbackFcn(app, @Link1EditFieldValueChanged, true);
            app.Link1EditField.HorizontalAlignment = 'center';
            app.Link1EditField.Position = [120 115 42 22];
            app.Link1EditField.Value = 1;

            % Create Link2EditFieldLabel
            app.Link2EditFieldLabel = uilabel(app.UIFigure);
            app.Link2EditFieldLabel.HorizontalAlignment = 'right';
            app.Link2EditFieldLabel.Position = [71 64 34 22];
            app.Link2EditFieldLabel.Text = 'Link2';

            % Create Link2EditField
            app.Link2EditField = uieditfield(app.UIFigure, 'numeric');
            app.Link2EditField.ValueChangedFcn = createCallbackFcn(app, @Link2EditFieldValueChanged, true);
            app.Link2EditField.HorizontalAlignment = 'center';
            app.Link2EditField.Position = [120 64 42 22];
            app.Link2EditField.Value = 1;

            % Create LinkLengthdefaultis1Label
            app.LinkLengthdefaultis1Label = uilabel(app.UIFigure);
            app.LinkLengthdefaultis1Label.Position = [70 159 137 22];
            app.LinkLengthdefaultis1Label.Text = 'Link Length (default is 1)';

            % Create Link3EditFieldLabel
            app.Link3EditFieldLabel = uilabel(app.UIFigure);
            app.Link3EditFieldLabel.HorizontalAlignment = 'right';
            app.Link3EditFieldLabel.Position = [71 17 34 22];
            app.Link3EditFieldLabel.Text = 'Link3';

            % Create Link3EditField
            app.Link3EditField = uieditfield(app.UIFigure, 'numeric');
            app.Link3EditField.ValueChangedFcn = createCallbackFcn(app, @Link3EditFieldValueChanged, true);
            app.Link3EditField.HorizontalAlignment = 'center';
            app.Link3EditField.Position = [120 17 42 22];
            app.Link3EditField.Value = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SphericalJoint_app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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