//go:build mage

package main

import (
    "github.com/magefile/mage/sh"
)

func Build() error {
    if err := sh.Run("go", "mod", "download"); err != nil {
        return err
    }
    return sh.Run("go", "install", "./...")
}

func Check() error {
    if err := sh.Run("go", "mod", "download"); err != nil {
        return err
    }
    return sh.Run("go", "test", "./...")
}
