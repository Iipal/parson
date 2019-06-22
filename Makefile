# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tmaluh <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/06/12 13:21:37 by tmaluh            #+#    #+#              #
#    Updated: 2019/06/14 13:47:31 by tmaluh           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME := libparson.a
NPWD := $(CURDIR)/$(NAME)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	LC := gcc-ar
endif
ifeq ($(UNAME_S),Darwin)
	LC := ar
endif

LC += rcs

CC := gcc -march=native -mtune=native -Ofast
CC_DEBUG := gcc -march=native -mtune=native -g3 -D DEBUG -fsanitize=address
CFLAGS := -Wall -Wextra -Werror -Wunused
INC := -I $(CURDIR)/includes/

SRC_D := srcs/
SRCS := $(abspath parson.c)
OBJS := $(SRCS:%.c=%.o)

DEL := rm -rf

WHITE := \033[0m
GREEN := \033[32m
RED := \033[31m
INVERT := \033[7m

SUCCESS = [$(GREEN)✓$(WHITE)]

all: $(NAME)

$(NAME): $(OBJS)
	@echo "$(INVERT)"
	@echo -n ' <=-=> | $(NPWD): '
	@$(LC) $(NAME) $(OBJS)
	@echo "[$(GREEN)✓$(WHITE)$(INVERT)]$(WHITE)"
	@echo

$(OBJS): %.o: %.c
	@echo -n ' $@: '
	@$(CC) -c $(CFLAGS) $(INC) $< -o $@
	@echo "$(SUCCESS)"

del:
	@$(DEL) $(OBJS)
	@$(DEL) $(NAME)

pre: del $(NAME)
	@echo "$(INVERT)$(GREEN)Successed re-build.$(WHITE)"

set_cc_debug:
	@$(eval CC=$(CC_DEBUG))
debug_all: set_cc_debug pre
	@echo "$(INVERT)$(NAME) $(GREEN)ready for debug.$(WHITE)"
debug: set_cc_debug all
	@echo "$(INVERT)$(NAME) $(GREEN)ready for debug.$(WHITE)"

clean:
	@$(DEL) $(OBJS)

fclean: clean
	@$(DEL) $(NAME)
	@echo "$(INVERT)$(RED)deleted$(WHITE)$(INVERT): $(NPWD)$(WHITE)"

re: fclean all

.PHONY: re fclean clean all del pre debug debug_all
