clc;
clear;
close all;
Sim = true;
l1 = 1; l2 =1;l3 = 1;
alpha1 = 0; beta1 = 0; gamma1 = 0;
alpha2 = 0; beta2 = 0; gamma2 = 0;
alpha3 = pi/2; beta3 = 0; gamma3 = 0;
rel_pos = [0 0 0 1]';

T1 = trans(l1, 'y');
T2 = trans(l2, 'y');
T3 = trans(l3, 'y');

RX1 = rot(alpha1, 'x');
RY1 = rot(beta1, 'y');
RZ1 = rot(gamma1, 'z');

RX2 = rot(alpha2, 'x');
RY2 = rot(beta2, 'y');
RZ2 = rot(gamma2, 'z');

RX3 = rot(alpha3, 'x');
RY3 = rot(beta3, 'y');
RZ3 = rot(gamma3, 'z');

J4 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*RZ3*RX3*RY3*T3*rel_pos;
J3 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*rel_pos;
J2 = RZ1*RX1*RY1*T1*rel_pos;
J1 = rel_pos;

act_pos = [J1 J2 J3 J4];
act_pos = act_pos(1:3,:);
f =figure;
p = plot3(act_pos(1,:),act_pos(2,:),act_pos(3,:),'o','LineStyle','-','LineWidth',2,'Color','k','MarkerFaceColor','g');
xlabel('x');ylabel('y');zlabel('z');
aximLim = 4;
grid on;
grid minor;
axis([-aximLim aximLim -aximLim aximLim -aximLim aximLim]);
hold on
% p1 = patch(act_pos(1,1:3),act_pos(2,1:3),act_pos(3,1:3),[1 1 0]);
% p2 = patch(act_pos(1,2:4),act_pos(2,2:4),act_pos(3,2:4),[0 0 1]);

while Sim
    RX1 = rot(alpha1, 'x');
    RY1 = rot(beta1, 'y');
    RZ1 = rot(gamma1, 'z');
    
    RX2 = rot(alpha2, 'x');
    RY2 = rot(beta2, 'y');
    RZ2 = rot(gamma2, 'z');
    
    RX3 = rot(alpha3, 'x');
    RY3 = rot(beta3, 'y');
    RZ3 = rot(gamma3, 'z');
    
    J4 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*RZ3*RX3*RY3*T3*rel_pos;
    J3 = RZ1*RX1*RY1*T1*RZ2*RX2*RY2*T2*rel_pos;
    J2 = RZ1*RX1*RY1*T1*rel_pos;
    J1 = rel_pos;
    
    act_pos = [J1 J2 J3 J4];
    act_pos = act_pos(1:3,:);

    delta1 = LinkAngleCalc(act_pos(:,2)-act_pos(:,1), act_pos(:,3)-act_pos(:,2));
    delta2 = LinkAngleCalc(act_pos(:,3)-act_pos(:,2), act_pos(:,4)-act_pos(:,3));
    
    set(p,'XData', act_pos(1,:),'YData', act_pos(2,:),'ZData', act_pos(3,:));
    axis([-aximLim aximLim -aximLim aximLim -aximLim aximLim]);
    
    drawnow;
end
%%Angle between links



function R = rot(theta,axis_name)
    if axis_name == 'x'
        R = [1 0 0 0; 0 cos(theta) -sin(theta) 0; 0 sin(theta) cos(theta) 0; 0 0 0 1];
    elseif axis_name == 'y'
        R = [cos(theta) 0 sin(theta) 0; 0 1 0 0; -sin(theta) 0 cos(theta) 0; 0 0 0 1];
    elseif axis_name == 'z'
        R = [cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0;0 0 1 0; 0 0 0 1];
    end
end

function T = trans(d, axis_name)
    if axis_name == 'x'
        T = [1 0 0 d;0 1 0 0;0 0 1 0;0 0 0 1];
    elseif axis_name == 'y'
        T = [1 0 0 0;0 1 0 d;0 0 1 0;0 0 0 1];
    elseif axis_name == 'z'
        T = [1 0 0 0;0 1 0 l0;0 0 1 d;0 0 0 1];
    end
end

function delta = LinkAngleCalc(vec1,vec2)
    delta = rad2deg(acos(dot(vec2,vec1)/(norm(vec1)*norm(vec2))));
end