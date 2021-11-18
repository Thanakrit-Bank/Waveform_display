classdef waveform_dis_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        GridLayout               matlab.ui.container.GridLayout
        LeftPanel                matlab.ui.container.Panel
        AmplitudeEditField       matlab.ui.control.NumericEditField
        AmplitudeEditFieldLabel  matlab.ui.control.Label
        FrequencyEditField       matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel  matlab.ui.control.Label
        AmplitudeKnob            matlab.ui.control.Knob
        AmplitudeKnobLabel       matlab.ui.control.Label
        FrequencyKnob            matlab.ui.control.Knob
        FrequencyKnobLabel       matlab.ui.control.Label
        WaveFormDropDown         matlab.ui.control.DropDown
        WaveFormDropDownLabel    matlab.ui.control.Label
        RightPanel               matlab.ui.container.Panel
        PlotButton               matlab.ui.control.Button
        UIAxes                   matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
           fs = 512;
           dt = 1/fs;
           StopTime = 0.25;
           t = (0:dt:StopTime-dt)';

           A = app.AmplitudeEditField.Value;
           F = app.FrequencyEditField.Value;

           switch app.WaveFormDropDown.Value
                case 'Sine Wave'
                    data = A*sin(2*pi*F*t);
                    plot(app.UIAxes,data)
                case 'Square Wave'
                    data = A*square(2*pi*F*t);
                    plot(app.UIAxes,data)
                case 'Triangle Wave'
                    data = A*sawtooth(2*pi*F*t,1/2);
                    plot(app.UIAxes,data)
                case 'Sawtooth Wave'
                    data = A*sawtooth(2*pi*F*t);
                    plot(app.UIAxes,data)
            end
        end

        % Drop down opening function: WaveFormDropDown
        function WaveFormDropDownOpening(app, event)
            
        end

        % Value changed function: FrequencyEditField
        function FrequencyEditFieldValueChanged(app, event)
            value = app.FrequencyEditField.Value;
            
        end

        % Value changed function: AmplitudeEditField
        function AmplitudeEditFieldValueChanged(app, event)
            value = app.AmplitudeEditField.Value;            
        end

        % Value changing function: FrequencyKnob
        function FrequencyKnobValueChanging(app, event)
            changingValue = event.Value;
            app.FrequencyEditField.Value = event.Value;
        end

        % Value changed function: FrequencyKnob
        function FrequencyKnobValueChanged(app, event)
            value = app.FrequencyKnob.Value;
        end

        % Value changing function: AmplitudeKnob
        function AmplitudeKnobValueChanging(app, event)
            changingValue = event.Value;
            app.AmplitudeEditField.Value = event.Value;
        end

        % Value changed function: AmplitudeKnob
        function AmplitudeKnobValueChanged(app, event)
            value = app.AmplitudeKnob.Value;
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {479, 479};
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
            app.UIFigure.Position = [100 100 926 479];
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

            % Create WaveFormDropDownLabel
            app.WaveFormDropDownLabel = uilabel(app.LeftPanel);
            app.WaveFormDropDownLabel.HorizontalAlignment = 'right';
            app.WaveFormDropDownLabel.Position = [20 427 67 22];
            app.WaveFormDropDownLabel.Text = 'Wave Form';

            % Create WaveFormDropDown
            app.WaveFormDropDown = uidropdown(app.LeftPanel);
            app.WaveFormDropDown.Items = {'Sine Wave', 'Square Wave', 'Triangle Wave', 'Sawtooth Wave'};
            app.WaveFormDropDown.DropDownOpeningFcn = createCallbackFcn(app, @WaveFormDropDownOpening, true);
            app.WaveFormDropDown.Position = [102 427 100 22];
            app.WaveFormDropDown.Value = 'Sine Wave';

            % Create FrequencyKnobLabel
            app.FrequencyKnobLabel = uilabel(app.LeftPanel);
            app.FrequencyKnobLabel.HorizontalAlignment = 'center';
            app.FrequencyKnobLabel.Position = [80 261 66 22];
            app.FrequencyKnobLabel.Text = ' Frequency';

            % Create FrequencyKnob
            app.FrequencyKnob = uiknob(app.LeftPanel, 'continuous');
            app.FrequencyKnob.Limits = [0 1000];
            app.FrequencyKnob.MajorTicks = [0 100 200 300 400 500 600 700 800 900 1000];
            app.FrequencyKnob.ValueChangedFcn = createCallbackFcn(app, @FrequencyKnobValueChanged, true);
            app.FrequencyKnob.ValueChangingFcn = createCallbackFcn(app, @FrequencyKnobValueChanging, true);
            app.FrequencyKnob.Position = [81 317 60 60];

            % Create AmplitudeKnobLabel
            app.AmplitudeKnobLabel = uilabel(app.LeftPanel);
            app.AmplitudeKnobLabel.HorizontalAlignment = 'center';
            app.AmplitudeKnobLabel.Position = [80 53 62 22];
            app.AmplitudeKnobLabel.Text = 'Amplitude ';

            % Create AmplitudeKnob
            app.AmplitudeKnob = uiknob(app.LeftPanel, 'continuous');
            app.AmplitudeKnob.Limits = [0 1000];
            app.AmplitudeKnob.MajorTicks = [0 100 200 300 400 500 600 700 800 900 1000];
            app.AmplitudeKnob.ValueChangedFcn = createCallbackFcn(app, @AmplitudeKnobValueChanged, true);
            app.AmplitudeKnob.ValueChangingFcn = createCallbackFcn(app, @AmplitudeKnobValueChanging, true);
            app.AmplitudeKnob.Position = [80 109 60 60];

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.LeftPanel);
            app.FrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.FrequencyEditFieldLabel.Position = [17 228 65 22];
            app.FrequencyEditFieldLabel.Text = ' Frequency';

            % Create FrequencyEditField
            app.FrequencyEditField = uieditfield(app.LeftPanel, 'numeric');
            app.FrequencyEditField.ValueChangedFcn = createCallbackFcn(app, @FrequencyEditFieldValueChanged, true);
            app.FrequencyEditField.Position = [97 228 100 22];

            % Create AmplitudeEditFieldLabel
            app.AmplitudeEditFieldLabel = uilabel(app.LeftPanel);
            app.AmplitudeEditFieldLabel.HorizontalAlignment = 'right';
            app.AmplitudeEditFieldLabel.Position = [20 19 62 22];
            app.AmplitudeEditFieldLabel.Text = 'Amplitude ';

            % Create AmplitudeEditField
            app.AmplitudeEditField = uieditfield(app.LeftPanel, 'numeric');
            app.AmplitudeEditField.ValueChangedFcn = createCallbackFcn(app, @AmplitudeEditFieldValueChanged, true);
            app.AmplitudeEditField.Position = [97 19 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Signal waveform')
            xlabel(app.UIAxes, 'Frequency(Hz)')
            ylabel(app.UIAxes, 'Amplitude(m)')
            app.UIAxes.Position = [3 121 697 328];

            % Create PlotButton
            app.PlotButton = uibutton(app.RightPanel, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.FontSize = 18;
            app.PlotButton.Position = [312 43 130 42];
            app.PlotButton.Text = 'Plot';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = waveform_dis_exported

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