NAME	= arkanoid
UNAME_S := $(shell uname -s)
DEBUG	= yes
ifeq ($(DEBUG),yes)
	FLAGS=-Wall -Wextra -Werror
else
	FLAGS= -g
endif
LDFLAGS	= -I./inc/ -I./libft/include/ -I./glfw/include/
SRC		= \
			main.c init.c draw.c move_n_hooks.c parser.c misc.c \
			win_n_loose.c math.c file.c
OBJ		= $(SRC:.c=.o)
SRCDIR	= ./src/
OBJDIR	= ./obj/
INCDIR	= ./inc/
INC		= arkanoid.h
SRCS	= $(addprefix $(SRCDIR), $(SRC))
OBJS	= $(addprefix $(OBJDIR), $(OBJ))
INCS	= $(addprefix $(INCDIR), $(INC))
ifeq ($(UNAME_S),Linux)
	LIBFLAG = -L./libft/ -lft -L./glfw/src -lglfw3 -lGL -lGLU -lglut -lX11 -lXxf86vm -lpthread -ldl -lm -lXi -lXrandr -lXcursor -lXinerama
endif
ifeq ($(UNAME_S),Darwin)
	LIBFLAG = -L./libft/ -lft -L./glfw/src/ -lglfw3 -framework Cocoa \
	-framework OpenGL -framework IOKit -framework CoreVideo \
	-framework GLUT
endif
.SILENT:

all: $(NAME)

$(NAME): $(OBJS)
	make -C libft/
	gcc $(FLAGS) -o $@ $^ $(LIBFLAG)
	echo "\\033[1;32mSuccess.\\033[0;39m"

$(OBJS): $(SRCS)
ifeq ($(DEBUG),yes)
	echo "\\033[1;31mDEBUG COMPILATION.. (no flags except -g)\\033[0;39m"
else
	echo "\\033[1;31mCompilation with -Wall -Wextra -Werror...\\033[0;39m"
endif
	echo "\\033[1;34mGenerating objects... Please wait.\\033[0;39m"
	git submodule init
	git submodule update
	cd glfw/ && cmake . ;
	make -C glfw/
	gcc $(FLAGS) -c $(SRCS) $(LDFLAGS) -Wno-deprecated
	mkdir -p $(OBJDIR)
	mv $(OBJ) $(OBJDIR)

.PHONY: clean fclean re

clean:
	echo "\\033[1;34mDeleting objects...\\033[0;39m"
	rm -f $(OBJS)

fclean: clean
	make fclean -C libft/
	echo "\\033[1;34mDeleting $(NAME)\\033[0;39m"
	rm -f $(NAME)

re: fclean all
