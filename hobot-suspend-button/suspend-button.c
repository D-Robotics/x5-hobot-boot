#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <string.h>

int main() {
    int fd;
    int count=0;
    struct input_event ie;

    fd = open("/dev/input/event0", O_RDONLY);
    if (fd == -1) {
        perror("Failed to open device");
        return EXIT_FAILURE;
    }

    while (1) {
        ssize_t bytes = read(fd, &ie, sizeof(struct input_event));
        if (bytes == (ssize_t) sizeof(struct input_event)) {
            if (ie.type == EV_KEY && ie.code == 143) {
                if (ie.value == 2)
                {
                    count=1;
                }
                if(count == 1 && ie.value == 0)
                {
                    count = 0;
                    system("/usr/bin/hobot-suspend");
                }
            }
        } else {
            perror("Failed to read event");
            close(fd);
            return EXIT_FAILURE;
        }
    }

    // 关闭设备
    close(fd);
    return EXIT_SUCCESS;
}
