% update_beam system
function update_beam_system(robot,x,r,p)

    enableEscape = 0;
    % rotate robot body     
    rotated_pts = EulerZYX_Fast([r p 0])*([robot.xx(:), robot.yy(:), robot.zz(:)]');
    robot.sh.XData = reshape(rotated_pts(1,:),size(robot.sh.XData)) + x;
    robot.sh.YData = reshape(rotated_pts(2,:),size(robot.sh.XData));
    min_Z  = min(rotated_pts(3,:));
    robot.sh.ZData = reshape(rotated_pts(3,:),size(robot.sh.XData)) - min_Z ;
    
    % find beam angle   
    robot.v = [x; 0; -min_Z];% update the shell parameters
    robot.R = EulerZYX_Fast([r p 0]);
    robot.M = robot.R*robot.A*robot.R';
   
    % left beam
    y_sec = robot.b20.yy(2):0.1:robot.b20.yy(1);     
    % stage 1 assigments
    stg1.v = robot.v - [zeros(size(y_sec)); y_sec; zeros(size(y_sec));  ] ;
    stg1.M = robot.M;
    stg1.a = stg1.M(1,1);
    stg1.b = stg1.M(3,3);
    stg1.c = 2*stg1.M(1,3);
    stg1.d = -2*stg1.M(1,:)*stg1.v;
    stg1.e = -2*stg1.M(3,:)*stg1.v;
    stg1.f = dot(stg1.v,robot.M*stg1.v) - 1;
    % stage 2 assigments -- find the tangent slopes for the section
    a =   stg1.e.*stg1.e - 4*stg1.f*stg1.b;
    b = 2*stg1.e.*stg1.d - 4*stg1.f*stg1.c;
    c =   stg1.d.*stg1.d - 4*stg1.f*stg1.a;
    % solve quadratic for slope 
    m1 = (-b + sqrt(b.*b-4*a.*c))./(2*a);
    m2 = (-b - sqrt(b.*b-4*a.*c))./(2*a);
    m1(imag(m1) ~=0) = nan;
    m2(imag(m2) ~=0) = nan;
    % find the contact point
    p1 = stg1.b.*m1.*m1 + stg1.c.*m1 + stg1.a;
    q1 = m1.*stg1.e + stg1.d;
    x1 = -q1./(2*p1);
    p2 = stg1.b.*m2.*m2 + stg1.c.*m2 + stg1.a;
    q2 = m2.*stg1.e + stg1.d;
    x2 = -q2./(2*p2);
    x = [x1 x2];
    y = [x1.*m1 x2.*m2];
    % find the angles
    th = atan2(x,y);
    valid_th_left = th(th <= (pi/2));
    valid_th_left(isnan(valid_th_left)) = [];

    % right beam
    y_sec = robot.b10.yy(2):0.1:robot.b10.yy(1);             
    % stage 1 assigments
    stg1.v = robot.v - [zeros(size(y_sec)); y_sec; zeros(size(y_sec));  ] ;
    stg1.M = robot.M;
    stg1.a = stg1.M(1,1);
    stg1.b = stg1.M(3,3);
    stg1.c = 2*stg1.M(1,3);
    stg1.d = -2*stg1.M(1,:)*stg1.v;
    stg1.e = -2*stg1.M(3,:)*stg1.v;
    stg1.f = dot(stg1.v,robot.M*stg1.v) - 1;
    % stage 2 assigments -- find the tangent slopes for the section
    a =   stg1.e.*stg1.e - 4*stg1.f*stg1.b;
    b = 2*stg1.e.*stg1.d - 4*stg1.f*stg1.c;
    c =   stg1.d.*stg1.d - 4*stg1.f*stg1.a;
    % solve quadratic for slope
    m1 = (-b + sqrt(b.*b-4*a.*c))./(2*a);
    m2 = (-b - sqrt(b.*b-4*a.*c))./(2*a);
    m1(imag(m1) ~=0) = nan;
    m2(imag(m2) ~=0) = nan;
    % find the contact point
    p1 = stg1.b.*m1.*m1 + stg1.c.*m1 + stg1.a;
    q1 = m1.*stg1.e + stg1.d;
    x1 = -q1./(2*p1);
    p2 = stg1.b.*m2.*m2 + stg1.c.*m2 + stg1.a;
    q2 = m2.*stg1.e + stg1.d;
    x2 = -q2./(2*p2);
    x = [x1 x2];
    y = [x1.*m1 x2.*m2];
    % find the angles
    th = atan2(x,y);
    valid_th_right = th(th <= (pi/2));    
    valid_th_right(isnan(valid_th_right)) = [];

        
    if(isempty(valid_th_left) )
        bending_angle_var(2) = 0;    
    else
        bending_angle_varLMax = max(valid_th_left);
        bending_angle_varLMin = min(valid_th_left);

        if(bending_angle_varLMax >= 0 && bending_angle_varLMin >= 0 && enableEscape)
             bending_angle_var(2) = 0;
        elseif(bending_angle_varLMax <= 0 && bending_angle_varLMin <= 0)
            bending_angle_var(2) = 0;
        else                
            bending_angle_var(2) = bending_angle_varLMax;
        end
    end


    if(isempty(valid_th_right))
        bending_angle_var(1) = 0;    
    else
        bending_angle_varRMax = max(valid_th_right);
        bending_angle_varRMin = min(valid_th_right);

         if(bending_angle_varRMax > 0 && bending_angle_varRMin > 0 && enableEscape )
             bending_angle_var(1) = 0;
         elseif(bending_angle_varRMax <= 0 && bending_angle_varRMin <= 0)
            bending_angle_var(1) = 0;
        else                
            bending_angle_var(1) = bending_angle_varRMax;
        end
    end
    
    
    robot.b1.ZData = cos(bending_angle_var(1))*robot.b10.zz;
    robot.b2.ZData = cos(bending_angle_var(2))*robot.b20.zz;
    robot.b1.XData = sin(bending_angle_var(1))*robot.b10.zz;
    robot.b2.XData = sin(bending_angle_var(2))*robot.b20.zz;