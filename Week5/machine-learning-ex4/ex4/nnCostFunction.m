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
X = [ones(m, 1) X];

% feed forward
z_2 = X*Theta1';
a_2 = [ones(m,1) sigmoid(z_2)];
z_3 = a_2*Theta2';
% hypothesis
h = sigmoid(z_3);
% terms for cost function
log_h = log(h);
log_h_sub = log(1-h);

% y_matrix = [1:num_labels] == y;
y_matrix = [];   % create a null matrix
for i = 1:num_labels
    y_matrix = [y_matrix y == i];
end
y_matrix_sub = 1-y_matrix;

left = y_matrix(:) .* log_h(:);
right = y_matrix_sub(:) .* log_h_sub(:);
penalty = (lambda/(2*m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));

J = -sum(left + right)/m + penalty;

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

%%%%%%%%%%%% Iteration Implementation %%%%%%%%%%%%%%%%%%%
      % for t = 1:m
      %   a_1 = X(t,:);
        
      %   z_2 = a_1*Theta1';
      %   a_2 = [1 sigmoid(z_2)];
        
      %   z_3 = a_2*Theta2';
      %   a_3 = sigmoid(z_3);
        
      %   delta_3 = a_3 - y_matrix(t,:);
      %   % size(delta_3)
      %   % size(z_2)
      %   delta_2 = (delta_3 * Theta2 ) .* sigmoidGradient([1 z_2]);
      %   delta_2 = delta_2(:, 2:end);

      %   Theta1_grad = Theta1_grad+ delta_2' * a_1;
      %   Theta2_grad = Theta2_grad + delta_3' * a_2;
      % endfor
%%%%%%%%%%%% Iteration Implementation %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Vectorization Implementation %%%%%%%%%%%%%%%%%%%
    a_1 = X;
    delta_3 = h - y_matrix;
    delta_2 = (delta_3 * Theta2) .* sigmoidGradient([ones(m,1) z_2]);
    delta_2 = delta_2(:, 2:end);

    Theta2_grad = delta_3' * a_2;
    Theta1_grad = delta_2' * a_1;
%%%%%%%%%%%% Vectorization Implementation %%%%%%%%%%%%%%%%%%%


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% regularization_term = lambda*(Theta1)

% Since we don't regularize the first column, we temporary replace the first color with a zero vector
Theta_1_regularization_term = (lambda/m) * [zeros(size(Theta1,1), 1) Theta1(:, 2:end)];
Theta_2_regularization_term = (lambda/m) * [zeros(size(Theta2,1), 1) Theta2(:, 2:end)];

% All column will be assigned as 1/m * Big_Delta, only j=1 (or the first column-bias unit) assigned immediately, other will add with the regularization term
Theta1_grad = (1/m) * Theta1_grad + Theta_1_regularization_term;
Theta2_grad = (1/m) * Theta2_grad + Theta_2_regularization_term;


















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end