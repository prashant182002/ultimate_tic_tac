import tensorflow as tf
import keras
from keras import layers
from keras.models import Model
from keras import models
from keras.optimizers import Adam
from keras.models import load_model
import numpy as np
import math
from collections import deque
import os
import time
from datetime import datetime
import h5py
import copy
import sys

# Hyperparameters
model_path = "C:\\Users\\pranky\\android\\tic_tac\\server\\ml\\GoodUltimate2024-08-03 +MCTS600+cpuct4.h5"
mcts_search = 400
MCTS = True
cpuct = 2


def get_empty_board():
    board = []

    for i in range(9):
        board.append([[" "," "," "],
        [" "," "," "],
        [" "," "," "]])
    return board

def possiblePos(board, subBoard):

    if subBoard == 9:
        return range(81)

    possible = []


    # otherwise, finds all available spaces in the subBoard
    if board[subBoard][1][1] != 'x' and board[subBoard][1][1] != 'o':
        for row in range(3):
            for coloumn in range(3):
                if board[subBoard][row][coloumn] == " ":
                    possible.append((subBoard * 9) + (row * 3) + coloumn)
        if len(possible) > 0:
            return possible

    # if the subboard has already been won, it finds all available spaces on the entire board
    for mini in range(9):
        if board[mini][1][1] == "x" or board[mini][1][1] == "o":
            continue
        for row in range(3):
            for coloumn in range(3):
                if board[mini][row][coloumn] == " ":
                    possible.append((mini * 9) + (row * 3) + coloumn)

    return possible


def move(board,action, player):

    if player == 1:
        turn = 'X'
    if player == -1:
        turn = "O"

    bestPosition = []

    bestPosition.append(int (action / 9))
    remainder = action % 9
    bestPosition.append(int (remainder/3))
    bestPosition.append(remainder%3)

    # place piece at position on board
    board[bestPosition[0]][bestPosition[1]][bestPosition[2]] = turn

    #set new subBoard
    newsubBoard = (bestPosition[1] * 3) + bestPosition[2]

    wonBoard=checker(board,player)

    return board, newsubBoard, wonBoard


def checker(board, player):

    if player == 1:
        turn = 'X'
    if player == -1:
        turn = "O"

    emptyMiniBoard = [[" "," "," "], [" "," "," "], [" "," "," "]]

    # wonBoard = False
    win = False

    for i in range(0, 9):
        mini=board[i]
        subBoard=i
        for y in range(0,3):
        #check for win on verticle
            if mini[0][y] == mini[1][y] == mini [2][y]!=" ":
                board[subBoard] = emptyMiniBoard
                board[subBoard][1][1] = turn.lower()
                # wonBoard = True

        #check for win on horozontal
        for x in range(0,3):
            if mini[x][0] == mini[x][1] == mini [x][2]!=" ":
                board[subBoard] = emptyMiniBoard
                board[subBoard][1][1] = turn.lower()
                # wonBoard = True

        #check for win on negative diagonal
        if mini[0][0] == mini[1][1] == mini [2][2]!=" ":
            board[subBoard] = emptyMiniBoard
            board[subBoard][1][1] = turn.lower()
            # wonBoard = True

        #check for win on positive diagonal
        if  mini[0][2] == mini[1][1] == mini[2][0]!=" ":
            board[subBoard] = emptyMiniBoard
            board[subBoard][1][1] = turn.lower()
            # wonBoard = True

    # if wonBoard == True:
    win = checkWinner(board, turn)

    return win

def checkWinner(board, turn):

    # making winning subBoard using just centre pieces
    winningBoard = [
    [board[0][1][1], board[1][1][1], board[2][1][1]],
    [board[3][1][1], board[4][1][1], board[5][1][1]],
    [board[6][1][1], board[7][1][1], board[8][1][1]]
    ]

    # horozontal and vertical wins
    for i in range(0,3):
        if turn.lower() == winningBoard[i][0] == winningBoard[i][1] == winningBoard[i][2]:
            return True
        if turn.lower() == winningBoard[0][i] == winningBoard[1][i] == winningBoard[2][i]:
            return True
    # top left to bottom right diagonal
    if turn.lower() == winningBoard[0][0] == winningBoard[1][1] == winningBoard[2][2]:
        return True
    # bottom left to top right diagonal
    if turn.lower() == winningBoard[2][0] == winningBoard[1][1] == winningBoard[0][2]:
        return True
    return False

# ---------------------------------
# Functions for neural network
# --------------------------------

# initializing search tree
Q = {}  # state-action values
Nsa = {}  # number of times certain state-action pair has been visited
Ns = {}   # number of times state has been visited
W = {}  # number of total points collected after taking state action pair
P = {}  # initial predicted probabilities of taking certain actions in state to cache the probs

def fill_winning_boards(board):

    # takes in a board in its normal state, and converts all suboards that have been won to be filled with the winning player's piece

    new_board = []
    for suboard in board:
        if suboard[1][1] =='x':
            new_board.append([["X","X","X"],["X","X","X"],["X","X","X"]])
        elif suboard[1][1] =='o':
            new_board.append([["O","O","O"],["O","O","O"],["O","O","O"]])
        else:
            new_board.append(suboard)
    return new_board

def letter_to_int(letter, player):
    # based on the letter in a box in the board, replaces 'X' with 1 and 'O' with -1
    if letter == 'v':
        return 0.1
    elif letter == " ":
        return 0
    elif letter == "X":
        return 1 * player
    elif letter =="O":
        return -1 * player

def board_to_array(boardreal, mini_board, player):

    # makes copy of board, so that the original board does not get changed
    board = copy.deepcopy(boardreal)

    # takes a board in its normal state, and returns a 9x9 numpy array, changing 'X' = 1 and 'O' = -1
    # also places a 0.1 in all valid board positions

    board = fill_winning_boards(board)
    tie = True

    # if it is the first turn, then all of the cells are valid moves
    if mini_board == 9:
        return np.full((9,9), 0.1)

    # replacing all valid positions with 'v'
    # checking whether all empty values on the board are valid
    if board[mini_board][1][1] != 'x' or board[mini_board][1][1] != 'o':
        for line in range(3):
            for item in range(3):
                if board[mini_board][line][item] == " ":
                    board[mini_board][line][item] = 'v'
                    tie = False
    # if not, then replacing empty cells in mini board with 'v'
    else:
        for suboard in range (9):
            for line in range(3):
                for item in range(3):
                    if board[suboard][line][item] == " ":
                        board[suboard][line][item] = 'v'

    # if the miniboard ends up being a tie
    if tie:
        for suboard in range (9):
            for line in range(3):
                for item in range(3):
                    if board[suboard][line][item] == " ":
                        board[suboard][line][item] = 'v'


    array = []
    firstline = []
    secondline = []
    thirdline = []

    for suboardnum in range(len(board)):

        for item in board[suboardnum][0]:
            firstline.append(letter_to_int(item, player))

        for item in board[suboardnum][1]:
            secondline.append(letter_to_int(item, player))

        for item in board[suboardnum][2]:
            thirdline.append(letter_to_int(item, player))

        if (suboardnum + 1) % 3 == 0:
            array.append(firstline)
            array.append(secondline)
            array.append(thirdline)
            firstline = []
            secondline = []
            thirdline = []

    nparray = np.array(array)

    return nparray

def mcts(s, current_player, mini_board):

    if mini_board == 9:
        possibleA = range(81)
    else:
        possibleA = possiblePos(s, mini_board)

    sArray = board_to_array(s, mini_board, current_player)
    sTuple = tuple(map(tuple, sArray))

    if len(possibleA) > 0:
        if sTuple not in P.keys():
            policy, v = nn.predict(sArray.reshape(1,9,9),verbose=0)
            # print(policy)
            v = v[0][0]
            valids = np.zeros(81)
            np.put(valids,possibleA,1)
            policy = policy.reshape(81) * valids
            policy = policy / np.sum(policy)
            P[sTuple] = policy

            Ns[sTuple] = 1

            for a in possibleA:
                Q[(sTuple,a)] = 0
                Nsa[(sTuple,a)] = 0
                W[(sTuple,a)] = 0
            return -v

        best_uct = -100
        for a in possibleA:

            uct_a = Q[(sTuple,a)] + cpuct * P[sTuple][a] * (math.sqrt(Ns[sTuple]) / (1 + Nsa[(sTuple,a)]))

            if uct_a > best_uct:
                best_uct = uct_a
                best_a = a

        next_state, mini_board, wonBoard = move(s, best_a, current_player)

        if wonBoard:
            v = 1
        else:
            current_player *= -1
            v = mcts(next_state, current_player, mini_board)
    else:
        return 0

    W[(sTuple,best_a)] += v
    Ns[sTuple] += 1
    Nsa[(sTuple,best_a)] += 1
    Q[(sTuple,best_a)] = W[(sTuple,best_a)] / Nsa[(sTuple,best_a)]
    return -v

def get_action_probs(init_board, current_player, mini_board):

    for _ in range(mcts_search):
        s = copy.deepcopy(init_board)
        value = mcts(s, current_player, mini_board)

#     print ("done one iteration of MCTS")

    actions_dict = {}

    sArray = board_to_array(init_board, mini_board, current_player)
    sTuple = tuple(map(tuple, sArray))
    for a in possiblePos(init_board, mini_board):
        actions_dict[a] = Nsa[(sTuple,a)] / Ns[sTuple]
#     print ("actions dict-", actions_dict)
    action_probs = np.zeros(81)

    for a in actions_dict:
        np.put(action_probs, a, actions_dict[a], mode='raise')

    return action_probs

nn = load_model(model_path)

def playgame(board,boardToPlayOn):
#     print(board)
    global nn

    if MCTS:
        policy = get_action_probs(board, -1, boardToPlayOn)
        policy = policy / np.sum(policy)
    else:
        policy, value = nn.predict(board_to_array(board, boardToPlayOn, -1).reshape(1,9,9))
        possibleA = possiblePos(board,boardToPlayOn)
        valids = np.zeros(81)
        np.put(valids,possibleA,1)
        policy = policy.reshape(81) * valids
        policy = policy / np.sum(policy)

    action = np.argmax(policy)
#     print ("action", action)

    main=int (action / 9)
    local = action % 9

    return main, local

board = []
for i in range(9):
    board.append([[" "," "," "],
    [" "," "," "],
    [" "," "," "]])

arguments = sys.argv[1:]
nboard=arguments[0]
# print(nboard)
new_board=[]
for i in nboard:
    if i!="," and i!='[' and i!=']':
        new_board.append(i)
# print(new_board)
for i in range(81):
    if new_board[i]!=' ':
        mini=i//9
        rem=i%9
        r=rem//3
        c=rem%3
        if new_board[i]=='X':
            board[mini][r][c]="X"
        else:
            board[mini][r][c]="O"

# print(board)
# print(boardToPlayOn)
boardToPlayOn=arguments[1]
boardToPlayOn=int(boardToPlayOn)
print(playgame(board,boardToPlayOn))

