<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateIzinKeluarTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
{
    Schema::create('Izinkeluar', function (Blueprint $table) {
        $table->id();
        $table->unsignedBigInteger('user_id'); // Menyimpan ID Mahasiswa atau BAAK
        $table->unsignedBigInteger('approve_id')->nullable(); // ID pengguna 'baak' yang melakukan approval
        $table->text('reason'); // Alasan izin keluar
        $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending'); 
        $table->timestamp('time_out')->nullable(); // Waktu keluar
        $table->timestamp('time_in')->nullable(); // Waktu kembali
        $table->timestamps();

        // Relasi dengan tabel User (Mahasiswa atau BAAK) untuk user_id
        $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');

        // Relasi dengan tabel User (BAAK) untuk approve_id
        $table->foreign('approve_id')->references('id')->on('users')->onDelete('set null');
    });
}


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('Izinkeluar');
    }
};
