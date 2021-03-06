function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
% 
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Add Bias
A1 = X;
A1 = [ones(size(A1,1),1) A1];

%Input for Hidden layer
Z2 = A1 * Theta1';

%Calc g(z1) which equals to A1 
A2 = sigmoid(Z2);


%Add bias to A1
A2 = [ones(size(A2,1),1) A2];
Z3 = A2 * Theta2';
A3 = sigmoid(Z3);


% predict number for each trainset
maps = zeros(size(A3,1), size(A3,2));

for i=1:m
  maps(i,y(i)) = 1;
##  y_new(y(i),i)=1;
end

%Cost. First column of Theta needs to be excluded(From A0) 
J = -sum(sum(maps.*log(A3)+(1-maps).*log(1-A3)))/m + ...
      (lambda)*(sum(sum(Theta1(:,2:end).^2))+sum(sum(Theta2(:,2:end).^2)))/(2*m);


delta3 = A3-maps;
delta2 = (delta3*Theta2).*sigmoidGradient([ones(size(Z2,1),1) Z2]);
%delta2(:,1) = 1;
delta2 = delta2(:,2:end);
Theta2_grad = delta3'*A2;
Theta1_grad = delta2'*A1;
Theta2_grad = Theta2_grad/m;
Theta1_grad = Theta1_grad/m;

Theta1_grad(:, 2:end) +=(lambda/m) * Theta1(:, 2:end);
Theta2_grad(:, 2:end) +=(lambda/m) * Theta2(:, 2:end);
% Back propagation
##for t=1:m
##
##    % Step 1
##	a1 = A1(t,:); % X already have a bias (1*401)
##    a1 = a1'; % (401*1)
##	z2 = Theta1 * a1; % (25*401)*(401*1)
##	a2 = sigmoid(z2); % (25*1)
##    
##    a2 = [1 ; a2]; % adding a bias (26*1)
##	z3 = Theta2 * a2; % (10*26)*(26*1)
##	a3 = sigmoid(z3); % final activation layer a3 == h(theta) (10*1)
##    
##    % Step 2
##	delta_3 = a3 - y_new(:,t); % (10*1)
##	
##    z2=[1; z2]; % bias (26*1)
##    % Step 3
##    delta_2 = (Theta2' * delta_3) .* sigmoidGradient(z2); % ((26*10)*(10*1))=(26*1)
##
##    % Step 4
##	delta_2 = delta_2(2:end); % skipping sigma2(0) (25*1)
##
##	Theta2_grad = Theta2_grad + delta_3 * a2'; % (10*1)*(1*26)
##	Theta1_grad = Theta1_grad + delta_2 * a1'; % (25*1)*(1*401)
##    
##end;
##
##% Step 5
##Theta2_grad = (1/m) * Theta2_grad; % (10*26)
##Theta1_grad = (1/m) * Theta1_grad; % (25*401)
##
##
##% Part 3: Implement regularization with the cost function and gradients.
##%
##%         Hint: You can implement this around the code for
##%               backpropagation. That is, you can compute the gradients for
##%               the regularization separately and then add them to Theta1_grad
##%               and Theta2_grad from Part 2.
##
##% Regularization
##
##% Theta1_grad(:, 1) = Theta1_grad(:, 1) ./ m; % for j = 0
##% 
##Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + ((lambda/m) * Theta1(:, 2:end)); % for j >= 1 
##% 
##% Theta2_grad(:, 1) = Theta2_grad(:, 1) ./ m; % for j = 0
##% 
##Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + ((lambda/m) * Theta2(:, 2:end)); % for j >= 1


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];



end
