function [theta] = normalEqn(X, y)
%NORMALEQN Computes the closed-form solution to linear regression 
%   NORMALEQN(X,y) computes the closed-form solution to linear 
%   regression using the normal equations.



theta = zeros(size(X, 2), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the code to compute the closed form solution
%               to linear regression and put the result in theta.
%

% ---------------------- Sample Solution ----------------------
numIter = 200;
alpha = 0.1;
X1 = X(:,1); % ones
X2 = X(:,2:size(X,2)); % features to be normalized
[X2, mu, sigma] = featureNormalize(X);
Xnew = [X1 X2];
J = 0;
[Xnew J] = gradientDescentMulti(Xnew, y, theta, alpha, numIter);



% -------------------------------------------------------------


% ============================================================

end
